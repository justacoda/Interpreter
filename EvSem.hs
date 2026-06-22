
--------------------------------------------------------------------- 
-- SML EVALUATION SEMANTICS FOR IMP                                   
-- Roy Crole and Paula Severi 2024                                            
--------------------------------------------------------------------- 

module EvSem

where

import AST
import Basic
import Pretty

----------------------------------------------------------------
--  Code the function evalint for evaluating Integer Expressions
----------------------------------------------------------------


evalint :: IntExp -> State -> Int 
evalint (Int m) s =  m
evalint  (Var v) s =  lookUp s v
evalint (IopExp(Plus, e1, e2)) s = evalint e1 s + evalint e2 s
evalint (IopExp(Minus, e1, e2)) s = evalint e1 s - evalint e2 s
evalint (IopExp(Times, e1, e2)) s = evalint e1 s * evalint e2 s


                        
 
 ---------------------------------------------------------------------
-- Code the function evalbool for evaluating Boolean Expressions
-----------------------------------------------------------------------


evalbool :: BoolExp -> State -> Bool
evalbool (Bool b) s = b
evalbool (BopExp(Le, e1, e2)) s = evalint e1 s < evalint e2 s
evalbool (BopExp(Gr, e1, e2)) s = evalint e1 s > evalint e2 s
evalbool (BopExp(LeEq, e1, e2)) s = evalint e1 s <= evalint e2 s
evalbool (BopExp(GrEq, e1, e2)) s = evalint e1 s >= evalint e2 s

                                                                                    
--------------------------------------------------------------------------
-- Code the function evalcom for evaluating Commands
---------------------------------------------------------------------------

evalcom :: Com -> State -> State 
evalcom (Ass (v, e)) s = update s v (evalint e s) 
evalcom (Seq (c1, c2)) s1 = let s2 = evalcom c1 s1 in evalcom c2 s2
evalcom (If (e, c1, c2)) s = if evalbool e s then evalcom c1 s else evalcom c2 s
evalcom (While (e, c)) s =  if evalbool e s 
                            then let s' = evalcom c s in evalcom (While (e, c)) s' 
                            else s
