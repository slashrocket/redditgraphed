CREATE TABLE "subscribers" ("id" serial primary key, "count" integer, "subreddit" text, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL) ;
INSERT INTO schema_migrations (version) VALUES (20150117044130);
