sql commands

UPDATE postings p SET p.list_status = 1;# MySQL returned an empty result set (i.e. zero rows).

UPDATE subcategories s SET active_postings_count = (SELECT Count(*) FROM postings p WHERE p.subcategory_id = s.id AND p.list_status = '1');# MySQL returned an empty result set (i.e. zero rows).



Things to do:
1. rerun sphinx every 5 minutes
2. refresh cache after sphinx is rerun
