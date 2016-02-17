module LogicaProposicional (module LogicaProposicional) where

    class TiposConNormalizacion b where
        norm :: b -> b
    {-----------------------------------------------------------
        ------------------
            OPERADORES
        ------------------

            Np      ¬p          not
            Cpq     p -> q      ANpq    p->q = (¬p v q)
            Kpq     p ^  q      &&
            Opq     p v q       ||
            Epq     p <-> q     (p->q)^(q->p)
    ------------------------------------------------------------}
    infix 9 `n`
    infix 3 `k`
    infix 2 `o`
    infix 2 `c`
    infix 2 `e`


    data Logic a = Logic
        {valor :: Bool
        }      | Logic a `C` Logic a

        deriving (Show)

    
    n :: (Logic a) -> (Logic a)
    n a = Logic (not (valor a))

    k :: (Logic a) -> (Logic a) -> (Logic a)
    p `k` q = Logic ((valor p) && (valor q))

    o :: (Logic a) -> (Logic a) -> (Logic a)
    p `o` q = Logic ((valor p) || (valor q))

    c :: (Logic a) -> (Logic a) -> (Logic a)
    p `c` q = (n p) `o` q

    e :: (Logic a) -> (Logic a) -> (Logic a)
    p `e` q = (p `c` q) `k` (q `c` p)

    --infix :|
    --infix :<->:
