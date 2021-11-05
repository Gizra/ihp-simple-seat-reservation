

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.venues DISABLE TRIGGER ALL;

INSERT INTO public.venues (id, created_at, title, total_number_of_seats) VALUES ('3df7ec3c-5b4d-4ac2-bcf5-080dc68ac0f0', '2021-11-05 13:32:24.103475+02', 'Woodstock', 50);


ALTER TABLE public.venues ENABLE TRIGGER ALL;


ALTER TABLE public.events DISABLE TRIGGER ALL;

INSERT INTO public.events (id, created_at, start_time, end_time, venue_id, title) VALUES ('7a7e856f-8475-48f5-977b-21bb85133a88', '2021-11-05 13:32:32.882646+02', '2021-11-05 13:32:32.882646+02', '2021-11-05 13:32:32.882646+02', '3df7ec3c-5b4d-4ac2-bcf5-080dc68ac0f0', 'Pearl Jam');


ALTER TABLE public.events ENABLE TRIGGER ALL;


ALTER TABLE public.reservations DISABLE TRIGGER ALL;



ALTER TABLE public.reservations ENABLE TRIGGER ALL;


ALTER TABLE public.reservation_jobs DISABLE TRIGGER ALL;



ALTER TABLE public.reservation_jobs ENABLE TRIGGER ALL;


