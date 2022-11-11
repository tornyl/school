--TABLE novakovi;
-- 1)
(TABLE novakovi) UNION (TABLE kroupovi);
-- 2)
--(TABLE novakovi) UNION (TABLE kroupovi) UNION (TABLE kralikovi);


(TABLE novakovi) EXCEPT ((TABLE kroupovi) UNION (TABLE kralikovi));


--((TABLE novakovi) UNION (TABLE kroupovi) UNION (TABLE kralikovi)) EXCEPT ((TABLE novakovi) INTERSECT (TABLE kroupovi) INTERSECT (TABLE kralikovi));


--(TABLE novakovi) UNION (TABLE kroupovi);

--(TABLE novakovi) UNION (TABLE kroupovi) UNION (TABLE kralikovi);

--INSERT INTO novakovi (((TABLE kroupovi) UNION (TABLE kralikovi)) EXCEPT (TABLE novakovi));

--(TABLE novakovi) UNION (TABLE kroupovi);

--(TABLE novakovi) UNION (TABLE kroupovi) UNION (TABLE kralikovi);



--(TABLE novakovi) EXCEPT ((TABLE kroupovi) UNION (TABLE kralikovi))

--INSERT INTO novakovi ((TABLE kralikovi) EXCEPT (TABLE novakovi));

--INSERT INTO novakovi (((TABLE kralikovi) EXCEPT ((TABLE novakovi) UNION (TABLE kroupovi))) UNION ((TABLE kroupovi) EXCEPT ((TABLE novakovi) UNION (TABLE kralikovi))));

--DELETE FROM kroupovi;
--DELETE FROM kralikovi;


