 
------------------------------------------------------------------- 
-- HASKELL BASIC LIST AND STRING PROCESSING FUNCTIONS           
-- Roy L. Crole and Paula Severi 2024                                         
------------------------------------------------------------------- 

module Basic where


-- COMPLETE the code for  mem 
mem :: Eq a => a -> [a] -> Bool
mem = elem

-- COMPLETE  the code for  lookUp
lookUp :: Eq a => [(a,b)] -> a -> b
lookUp ((k,v):ns) key = if k == key then v else lookUp ns key
lookUp [] key = error "key not found"

-- COMPLETE  the code for  update
update :: Eq a => [(a, b)] -> a -> b -> [(a, b)]
update [] k' v' = [(k', v')]
update ((k,v):ps) k' v'
    | k' == k = (k, v') : ps
    | otherwise = (k, v) : update ps k' v' 
    