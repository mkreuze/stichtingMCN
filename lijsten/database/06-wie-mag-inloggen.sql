-- ============================================================
--  Wie mag een account aanmaken
--
--  Zonder dit bestand kan iedereen een account aanmaken; hij ziet
--  dan alleen niets, want de ledenlijst bepaalt wat je te zien
--  krijgt. Met dit bestand wordt zo iemand al bij de deur
--  tegengehouden: alleen e-mailadressen die in de tabel "leden"
--  staan, kunnen zich aanmelden.
--
--  Eén lijst dus: zet iemand in "leden" en hij kan inloggen; haal
--  hem eruit en dat kan niet meer.
--
--  NA HET DRAAIEN NOG ÉÉN HANDELING, in het Supabase-scherm:
--    Authentication → Hooks → Before User Created
--    → kies "Postgres function" → public.mag_account_aanmaken
--    → inschakelen en opslaan.
--  Zonder die handeling doet dit bestand niets.
-- ============================================================

-- De functie krijgt de aanmelding binnen als "event" en geeft die
-- ongewijzigd terug wanneer het adres op de lijst staat. Staat het er
-- niet op, dan komt er een foutmelding terug en gaat de aanmelding
-- niet door.
--
-- (Alles op één regel: sommige SQL-editors knippen een script bij
-- elke puntkomma en struikelen over meerregelige functies.)

create or replace function public.mag_account_aanmaken(event jsonb) returns jsonb language sql stable security definer set search_path = public as 'select case when exists (select 1 from leden where lower(email) = lower(event->''user''->>''email'')) then event else jsonb_build_object(''error'', jsonb_build_object(''http_code'', 403, ''message'', ''Dit e-mailadres staat niet op de lijst van mensen die deze lijst mogen gebruiken. Vraag de beheerder om je toe te voegen.'')) end';

-- Alleen het aanmeldsysteem van Supabase mag deze functie gebruiken.
grant usage on schema public to supabase_auth_admin;
grant execute on function public.mag_account_aanmaken(jsonb) to supabase_auth_admin;
revoke execute on function public.mag_account_aanmaken(jsonb) from authenticated, anon, public;
