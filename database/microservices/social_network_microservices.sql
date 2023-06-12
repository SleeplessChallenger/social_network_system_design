CREATE TABLE "posts" (
  "post_id" bigint PRIMARY KEY,
  "body" text,
  "author_id" integer,
  "date_added" timestamp,
  "images" string[],
  "likes" integer DEFAULT 0,
  "views" integer DEFAULT 0,
  "hashtags" integer,
  "comments" integer
);

CREATE TABLE "comments" (
  "comment_id" bigint PRIMARY KEY,
  "comment_content" text,
  "likes" integer DEFAULT 0,
  "posted_at" timestamp,
  "images" string[]
);

CREATE TABLE "parentChildComments" (
  "parent_comment" bigint,
  "child_comment" bigint
);

CREATE TABLE "likes" (
  "like_id" bigint PRIMARY KEY,
  "user_id" bigint,
  "comment_id" bigint,
  "post_id" bigint
);

CREATE TABLE "postsHastags" (
  "post_id" bigint,
  "tag_id" bigint
);

CREATE TABLE "hashtags" (
  "tag_id" bigint PRIMARY KEY,
  "tag_name" text
);

CREATE TABLE "users" (
  "user_id" bigint PRIMARY KEY,
  "name" varchar,
  "surname" varchar,
  "age" integer,
  "phone_number" integer,
  "image" string,
  "friends" integer,
  "interests" string,
  "city" string,
  "last_seen" timestamp
);

CREATE TABLE "relations" (
  "request_side" bigint,
  "accept_side" bigint
);

CREATE TABLE "channels" (
  "channel_id" bigint PRIMARY KEY,
  "channel_name" string
);

CREATE TABLE "messages" (
  "message_id" bigint,
  "channel_id" bigint,
  "author_id" integer,
  "message_content" text,
  "content_url" string[],
  "sent_at" timestamp
);

CREATE TABLE "last_seen" (
  "author_id" bigint,
  "channel_id" bigint,
  "message_id" bigint
);

CREATE TABLE "last_message" (
  "channel_id" bigint,
  "message_id" bigint
);

CREATE TABLE "S3BucketExample" (
  "SOCIAL_NETWORK_BUCKET" object,
  "SOCIAL_NETWORK_KEY" object
);

ALTER TABLE "likes" ADD FOREIGN KEY ("like_id") REFERENCES "comments" ("comment_id");

ALTER TABLE "parentChildComments" ADD FOREIGN KEY ("parent_comment") REFERENCES "comments" ("comment_id");

ALTER TABLE "parentChildComments" ADD FOREIGN KEY ("child_comment") REFERENCES "comments" ("comment_id");

ALTER TABLE "likes" ADD FOREIGN KEY ("like_id") REFERENCES "posts" ("post_id");

ALTER TABLE "comments" ADD FOREIGN KEY ("comment_id") REFERENCES "posts" ("post_id");

ALTER TABLE "relations" ADD FOREIGN KEY ("request_side") REFERENCES "users" ("user_id");

ALTER TABLE "relations" ADD FOREIGN KEY ("accept_side") REFERENCES "users" ("user_id");

ALTER TABLE "messages" ADD FOREIGN KEY ("message_id") REFERENCES "channels" ("channel_id");
