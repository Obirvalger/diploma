import qualified Data.Set as Set

allVectors k n = sequence $ map (\x -> [0..(k-1)]) [1..n]

posSgn x = if x == 0 then 0 else 1

indexesSubset b a = Set.isSubsetOf (setIndexes b) (setIndexes a)
    where setIndexes l = Set.fromList $ setIndexes' l [] 0
	  setIndexes' [] l n = l
          setIndexes' (x:xs) l n | x == 0 = setIndexes' xs l (n+1)
				 | otherwise = setIndexes' xs (n:l) (n+1)
				 
toKAry k n sz = (replicate (sz - (length val)) 0) ++ val
    where toKAry' k n l | n == 0    = l
			| otherwise = toKAry' k (div n k) ((mod n k) : l)
	  val = toKAry' k n []

fromKAry k l = sum $ zipWith (*) (map (k^) [0..(length l)]) $ reverse l

--cF :: (Integral t) => [t] -> [t] -> t
cF a f k n ekn = (-1) ^ (sum $ map posSgn a) * sum [product (zipWith (kPow) (notZero b) (notZero a)) * (fb b)| b <- ekn, indexesSubset b a] `mod` k
    where notZero = filter (/=0)
	  kPow bi ai = (bi ^ (k - 1 - ai))
	  fb b = f !! fromInteger (fromKAry k b)

toPolynomial f k n ekn = [cF a f k n ekn | a <- ekn]

polarize f d k n ekn = [f !! fromInteger (fromKAry k (zipWith (\x y -> (x - y) `mod` k) b d)) | b <- ekn]

lenPoly f k n = minimum $ map (length . filter (/=0)) [toPolynomial (polarize f d k n ekn) k n ekn | d <- ekn]
    where ekn = allVectors k n
