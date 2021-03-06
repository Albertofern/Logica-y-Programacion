module Escitala (cifrar, descifrar) where 
    
    import Data.Matrix      -- install with cabal install matrix
    import Data.Vector
    import Data.List

    cifrar :: String -> Int -> String
    cifrar texto n
        | b == 0 = cifrarAux (Data.Matrix.fromList a n texto) n ""
        | otherwise = cifrarAux (Data.Matrix.fromList (a+1) n (addWhiteSpaces texto b)) n ""
            where
                a = (Prelude.length texto) `div` n
                b = (Prelude.length texto) `mod` n

    descifrar :: String -> Int -> String
    descifrar texto n = dropWhileEnd (== ' ') (cifrarAux (Data.Matrix.fromList n a texto) a "")
        where
            a = (Prelude.length texto) `div` n
            b = (Prelude.length texto) `mod` n

    addWhiteSpaces :: String -> Int -> String
    addWhiteSpaces texto 0 = texto
    addWhiteSpaces texto n = addWhiteSpaces (texto Prelude.++ " ") (n-1)

    cifrarAux :: Matrix Char -> Int -> String -> String
    cifrarAux _ 0 r = r
    cifrarAux m n r = cifrarAux m (n-1) ((Data.Vector.toList (getCol n m)) Prelude.++ r)
