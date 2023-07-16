-- This SQL script select band_name, and lifespan column which is difference
SELECT origin, COUNT(*) as nb_fans
FROM metal_bands
GROUP BY origin
ORDER BY nb_fans DESC;


