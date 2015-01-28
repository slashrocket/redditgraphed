ALTER TABLE "subscribers" ADD "author" text;
ALTER TABLE "subscribers" ADD "permalink" text;
INSERT INTO schema_migrations (version) VALUES (20150120203958);
