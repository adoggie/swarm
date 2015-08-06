BEGIN;
CREATE TABLE "core_application" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(40) NOT NULL,
    "type" smallint NOT NULL,
    "is_active" boolean NOT NULL
)
;
CREATE TABLE "core_orgnization" (
    "id" serial NOT NULL PRIMARY KEY,
    "domain" varchar(60) NOT NULL,
    "name" varchar(60) NOT NULL,
    "address" varchar(100) NOT NULL,
    "zipcode" varchar(20) NOT NULL,
    "country" varchar(40) NOT NULL,
    "create_date" timestamp with time zone NOT NULL
)
;
CREATE TABLE "core_orguser" (
    "id" serial NOT NULL PRIMARY KEY,
    "org_id" integer NOT NULL REFERENCES "core_orgnization" ("id") DEFERRABLE INITIALLY DEFERRED,
    "user_type" smallint NOT NULL,
    "user_name" varchar(64) NOT NULL,
    "password" varchar(100) NOT NULL,
    "first_name" varchar(32),
    "last_name" varchar(32),
    "alias" varchar(32),
    "email" varchar(64) NOT NULL,
    "create_date" timestamp with time zone NOT NULL,
    "is_active" boolean NOT NULL,
    "login_time" timestamp with time zone NOT NULL,
    "total_times" integer NOT NULL
)
;
CREATE TABLE "core_orguserappconfig" (
    "id" serial NOT NULL PRIMARY KEY,
    "app_id" integer NOT NULL REFERENCES "core_application" ("id") DEFERRABLE INITIALLY DEFERRED,
    "user_id" integer NOT NULL REFERENCES "core_orguser" ("id") DEFERRABLE INITIALLY DEFERRED,
    "is_active" boolean NOT NULL,
    "app_access_token" varchar(2000),
    "app_instance_url" varchar(1000),
    "app_user_id" varchar(200),
    "app_user_name" varchar(60),
    "app_auth_time" timestamp with time zone NOT NULL
)
;
CREATE INDEX "core_orguser_org_id" ON "core_orguser" ("org_id");
CREATE INDEX "core_orguser_user_name" ON "core_orguser" ("user_name");
CREATE INDEX "core_orguser_user_name_like" ON "core_orguser" ("user_name" varchar_pattern_ops);
CREATE INDEX "core_orguser_password" ON "core_orguser" ("password");
CREATE INDEX "core_orguser_password_like" ON "core_orguser" ("password" varchar_pattern_ops);
CREATE INDEX "core_orguser_first_name" ON "core_orguser" ("first_name");
CREATE INDEX "core_orguser_first_name_like" ON "core_orguser" ("first_name" varchar_pattern_ops);
CREATE INDEX "core_orguser_last_name" ON "core_orguser" ("last_name");
CREATE INDEX "core_orguser_last_name_like" ON "core_orguser" ("last_name" varchar_pattern_ops);
CREATE INDEX "core_orguser_alias" ON "core_orguser" ("alias");
CREATE INDEX "core_orguser_alias_like" ON "core_orguser" ("alias" varchar_pattern_ops);
CREATE INDEX "core_orguser_email" ON "core_orguser" ("email");
CREATE INDEX "core_orguser_email_like" ON "core_orguser" ("email" varchar_pattern_ops);
CREATE INDEX "core_orguser_is_active" ON "core_orguser" ("is_active");
CREATE INDEX "core_orguserappconfig_app_id" ON "core_orguserappconfig" ("app_id");
CREATE INDEX "core_orguserappconfig_user_id" ON "core_orguserappconfig" ("user_id");

COMMIT;
