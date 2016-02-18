module Formula (module Formula) where

    import Arbol
    import Data.List

    --data Formula a b = (ArbolB a, [b])

    data Formula a b = Formula
            { arbol :: (ArbolB Char)
            , listaInts :: ([Int],[Int])
            }

    quitarParentesis :: String -> String
    quitarParentesis xs = quitarParentesis' (filter (/= ')') xs)
        where
            quitarParentesis' :: String -> String
            quitarParentesis' xs = filter (/='(') xs

    eliminarEspacios :: String -> String
    eliminarEspacios xs = filter (/= ' ') xs

    {-
        Caso 1: a v (b -> c)
        Caso 1.1: ¬a v (b -> c)
        Caso 1.2: a v (b -> ¬c)
        Caso 2: (a v b) -> c
        Caso 2.1: (a v b) -> ¬c
        Caso 2.2: (¬a v b) -> c
    -}
    crear :: String -> Formula a b
    crear xs
        | (head xs) == '(' = Formula (crearCaso2 ps ((length ps) - 1)) par
        | otherwise = Formula (crearCaso1 ps) par
            where
                ps  = eliminarEspacios (quitarParentesis xs)
                par = ((elemIndices '(' (eliminarEspacios xs)), (elemIndices ')' (eliminarEspacios xs)))
    
    crearCaso2 :: String -> Int -> ArbolB Char
    crearCaso2 xs 0 = hojaB (head xs)
    crearCaso2 xs 1 = NodoB (hojaB (xs !! 1)) (head xs) VacioB
    crearCaso2 xs n 
        | (xs !! (n-1)) == 'n' = NodoB (crearCaso2 xs (n-3)) (xs !! (n-2)) (NodoB (hojaB (xs !! n)) (xs !! (n-1)) VacioB)
        | otherwise            = NodoB (crearCaso2 xs (n-2)) (xs !! (n-1)) (hojaB (xs !! n))

    crearCaso1 :: String -> ArbolB Char
    crearCaso1 []    = VacioB
    crearCaso1 [x]   = hojaB x
    crearCaso1 [x,y] = NodoB (hojaB y) x VacioB
    crearCaso1 xs  
        | (xs !! 0) == 'n' = NodoB (NodoB (hojaB (xs !! 1)) (xs !! 0) VacioB) (xs !! 2) (crearCaso1 (drop 3 xs))
        | otherwise        = NodoB (hojaB (xs !! 0)) (xs !! 1) (crearCaso1 (drop 2 xs))

    addPar :: String -> [Int] -> [Int] -> String -> String
    addPar _ [] [] s         = s
    addPar y (l:ls) (k:ks) s = addPar w ls ks (s ++ w)
        where
            w = (insertar l '(' (insertar k ')' y))

    insertar :: Int -> Char -> String -> String
    insertar 0 y xs = y:xs
    insertar n y [] = [y]
    insertar n y xs
        | length xs < n = xs
        | otherwise = (take (n-1) xs) ++ [y] ++ (drop (n-1) xs)

    obtenerForm :: ArbolB Char -> [Char]
    obtenerForm VacioB = []
    obtenerForm (NodoB i r d) = (obtenerForm i) ++ [r] ++ obtenerForm d

    toString :: Formula a b -> String
    toString f = addPar (obtenerForm (arbol f)) (fst (listaInts f)) (snd (listaInts f)) ""

    reverse' :: [a] -> [a]
    reverse' xs = reverseAux xs []
      where
        reverseAux :: [a] -> [a] -> [a]
        reverseAux [] lst     = lst
        reverseAux (x:xs) lst = reverseAux xs (x:lst)


    instance Show a => Show (Formula a b) where
        showsPrec _ f = shows (reverse' (mostrar (toString f) ""))
            where 
                mostrar :: String -> String -> String
                mostrar "" s = s
                mostrar (x:xs) s
                    | x == 'n'  = mostrar xs ('¬':s)
                    | x == 'c'  = mostrar xs ('>':'-':s)
                    | x == 'k'  = mostrar xs ('^':s)
                    | x == 'o'  = mostrar xs ('v':s)
                    | x == 'e'  = mostrar xs ('>':'-':'<':s)
                    | otherwise = mostrar xs (x:s)