import Verbose.Tactics.By
import Verbose.English.Common

open Verbose.English


-- **FIXME** this `<|>` is too crude. We need to check whether `obtainTac` fails because of `checkName`. In that case,
-- reporting this failure is the right thing to do. Same may apply if the newStuff doesn't match?
elab "By " e:maybeApplied " we get " colGt news:newStuffEN : tactic => do
obtainTac (← maybeAppliedToTerm e) (newStuffENToArray news) <|> anonymousLemmaTac (← maybeAppliedToTerm e) (newStuffENToArray news)

elab "By " e:maybeApplied " we choose " colGt news:newStuffEN : tactic => do
chooseTac (← maybeAppliedToTerm e) (newStuffENToArray news)

elab "By " e:maybeApplied " it suffices to prove " "that "? colGt arg:term : tactic => do
bySufficesTac (← maybeAppliedToTerm e) #[arg]

elab "By " e:maybeApplied " it suffices to prove " "that "? colGt "["args:term,*"]" : tactic => do
bySufficesTac (← maybeAppliedToTerm e) args.getElems

lemma le_le_of_abs_le {α : Type*} [LinearOrderedAddCommGroup α] {a b : α} : |a| ≤ b → -b ≤ a ∧ a ≤ b := abs_le.1

lemma le_le_of_max_le {α : Type*} [LinearOrder α] {a b c : α} : max a b ≤ c → a ≤ c ∧ b ≤ c :=
max_le_iff.1

-- Using a local attribute to let projects define their own anonymous lemmas.
attribute [local anonymous_lemma] le_le_of_abs_le le_le_of_max_le

example (P : Nat → Prop) (h : ∀ n, P n) : P 0 := by
  By h applied to 0 we get h₀
  exact h₀

example (P : Nat → Nat → Prop) (h : ∀ n k, P n (k+1)) : P 0 1 := by
  By h applied to [0, 0] we get (h₀ : P 0 1)
  exact h₀

example (n : Nat) (h : ∃ k, n = 2*k) : True := by
  By h we get k such that (H : n = 2*k)
  trivial

example (n : Nat) (h : ∃ k, n = 2*k) : True := by
  By h we get k such that H
  trivial

example (P Q : Prop) (h : P ∧ Q)  : Q := by
  By h we get (hP : P) (hQ : Q)
  exact hQ

example (x : ℝ) (h : |x| ≤ 3) : True := by
  By h we get (h₁ : -3 ≤ x) (h₂ : x ≤ 3)
  trivial

example (n p q : ℕ) (h : n ≥ max p q) : True := by
  By h we get (h₁ : n ≥ p) (h₂ : n ≥ q)
  trivial

noncomputable example (f : ℕ → ℕ) (h : ∀ y, ∃ x, f x = y) : ℕ → ℕ := by
  By h we choose g such that (H : ∀ (y : ℕ), f (g y) = y)
  exact g


example (P Q : Prop) (h : P → Q) (h' : P) : Q := by
  By h it suffices to prove that P
  exact h'

example (P Q : Prop) (h : P → Q) (h' : P) : Q := by
  By h it suffices to prove P
  exact h'

example (P Q R : Prop) (h : P → R → Q) (hP : P) (hR : R) : Q := by
  By h it suffices to prove [P, R]
  exact hP
  exact hR

/-
example (P Q : Prop) (h : ∀ n : ℕ, P → Q) (h' : P) : Q := by
  success_if_fail_with_msg "Apply this leads to 0 goals, not 1."
    By h applied to [0, 1] it suffices to prove P
  By h applied to 0 it suffices to prove P
  exact h'
 -/

example (Q : Prop) (h : ∀ n : ℤ, n > 0 → Q)  : Q := by
  By h applied to 1 it suffices to prove 1 > 0
  norm_num
