CREATE TABLE "users" (
  "user_id" integer PRIMARY KEY,
  "name" varchar,
  "surname" varchar,
  "age" integer,
  "phone_number" integer,
  "image" string,
  "friends" integer,
  "interests" string,
  "city" string
);

CREATE TABLE "posts" (
  "post_id" integer PRIMARY KEY,
  "body" text,
  "author" integer,
  "date_added" timestamp,
  "image" string,
  "likes" integer DEFAULT 0,
  "views" integer DEFAULT 0,
  "hashtags" integer,
  "comments" integer
);

CREATE TABLE "likes" (
  "like_id" integer PRIMARY KEY,
  "user_id" integer,
  "post_comment_id" integer
);

CREATE TABLE "hashtags" (
  "tag_id" integer PRIMARY KEY,
  "tag_name" text
);

CREATE TABLE "tagPostCommentRelation" (
  "tag_id" integer,
  "post_id" integer,
  "comment_id" integer
);

CREATE TABLE "userPostCommentRelation" (
  "user_id" integer,
  "post_id" integer,
  "comment_id" integer
);

CREATE TABLE "comments" (
  "comment_id" integer PRIMARY KEY,
  "comment_content" text,
  "likes" integer DEFAULT 0,
  "posted_at" timestamp,
  "image" string
);

CREATE TABLE "parentChildComments" (
  "parent_comment" integer,
  "child_comment" integer
);

CREATE TABLE "messages" (
  "message_id" bigint,
  "channel_id" bigint,
  "author_id" integer,
  "message_content" text,
  "data_content" string,
  "sent_at" timestamp,
  "seen" boolean,
  "message_id_channel_id" bigint PRIMARY KEY
);

CREATE TABLE "relations" (
  "request_side" integer,
  "accept_side" integer
);

CREATE TABLE "S3BucketExample" (
  "SOCIAL_NETWORK_BUCKET" object,
  "SOCIAL_NETWORK_KEY" object
);

ALTER TABLE "tagPostCommentRelation" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("post_id");

ALTER TABLE "tagPostCommentRelation" ADD FOREIGN KEY ("tag_id") REFERENCES "hashtags" ("tag_id");

ALTER TABLE "tagPostCommentRelation" ADD FOREIGN KEY ("comment_id") REFERENCES "comments" ("comment_id");

ALTER TABLE "userPostCommentRelation" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "userPostCommentRelation" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("post_id");

ALTER TABLE "userPostCommentRelation" ADD FOREIGN KEY ("comment_id") REFERENCES "comments" ("comment_id");

ALTER TABLE "parentChildComments" ADD FOREIGN KEY ("parent_comment") REFERENCES "comments" ("comment_id");

ALTER TABLE "parentChildComments" ADD FOREIGN KEY ("child_comment") REFERENCES "comments" ("comment_id");

ALTER TABLE "likes" ADD FOREIGN KEY ("post_comment_id") REFERENCES "posts" ("likes");

ALTER TABLE "likes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "likes" ADD FOREIGN KEY ("post_comment_id") REFERENCES "comments" ("comment_id");

ALTER TABLE "messages" ADD FOREIGN KEY ("message_id") REFERENCES "users" ("user_id");

ALTER TABLE "relations" ADD FOREIGN KEY ("request_side") REFERENCES "users" ("user_id");

ALTER TABLE "relations" ADD FOREIGN KEY ("accept_side") REFERENCES "users" ("user_id");
