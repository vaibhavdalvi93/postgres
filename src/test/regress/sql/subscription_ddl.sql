--
-- Get CREATE SUBSCRIPTION statement
--

CREATE ROLE sub_nonsup_user LOGIN;

-- Create subscription with minimal options
CREATE SUBSCRIPTION testsub1 CONNECTION 'dbname=db_doesnotexist'
  PUBLICATION testpub1 WITH (connect=false);
-- Check that the subscription ddl is correctly created
SELECT pg_get_subscription_ddl('testsub1');

-- Create subscription with more options
CREATE SUBSCRIPTION "TestSubddL2" CONNECTION 'host=unknown user=dvd password=pass123'
  PUBLICATION "testpub2", "TestPub3" WITH (connect=false, slot_name='slot1',
  enabled=off);
SELECT pg_get_subscription_ddl('TestSubddL2');

-- Create subscription with all options
CREATE SUBSCRIPTION testsub3 CONNECTION 'host=unknown user=dvd password=pass12'
  PUBLICATION testpub4 WITH (connect=false, slot_name=none, enabled=false,
  create_slot=false, copy_data=false, binary=true, streaming=off,
  synchronous_commit=local, two_phase=true, disable_on_error=true,
  password_required=false, run_as_owner=true, origin=none, failover=true);
SELECT pg_get_subscription_ddl('testsub3');

-- Non-superuser can't see subscription ddl
SET SESSION AUTHORIZATION 'sub_nonsup_user';
SELECT pg_get_subscription_ddl('TestSubddL2');
RESET SESSION AUTHORIZATION;
-- Administrators can change who can access this function
GRANT EXECUTE ON FUNCTION pg_get_subscription_ddl TO sub_nonsup_user;
SET SESSION AUTHORIZATION 'sub_nonsup_user';
SELECT pg_get_subscription_ddl('TestSubddL2');

RESET SESSION AUTHORIZATION;
REVOKE EXECUTE ON FUNCTION pg_get_subscription_ddl FROM sub_nonsup_user;
ALTER SUBSCRIPTION testsub1 SET (slot_name=NONE);
DROP SUBSCRIPTION testsub1;
ALTER SUBSCRIPTION "TestSubddL2" SET (slot_name=NONE);
DROP SUBSCRIPTION "TestSubddL2";
DROP SUBSCRIPTION testsub3;
DROP ROLE sub_nonsup_user;
