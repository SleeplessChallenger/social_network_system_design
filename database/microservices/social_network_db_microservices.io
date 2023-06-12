/*
Helpful links:
1. How Discord moved from MongoDB to Cassandra: https://discord.com/blog/how-discord-stores-billions-of-messages
2. How companies store data: https://stackoverflow.com/a/70720330/16543524
3. How to store hashtags? https://stackoverflow.com/a/24800716/16543524
4. How to store comments? https://nehajirafe.medium.com/data-modeling-designing-facebook-style-comments-with-sql-4cf9e81eb164
*/

// Social network diagram

/*
It is a an overall example if we have a microservice
Here I use multiple databases: relational: PostgreSQL, non-relational: MongoDB, blob storage: S3
*/

// First microservice: responsible for Posts, Comments, Likes, Hashtags

/*
API will accept data with user_id
I.e. User writes/likes post or comment -> request is sent to the service with user_id
*/

Table posts {
  post_id bigint [primary key]
  body text
  author_id integer
  date_added timestamp
  images string[] [null] // link to the position in S3
  likes integer [default: 0]
  views integer [default: 0] // Ideally, also create a table to track who has seen the post
  hashtags integer [null]
  comments integer [null]
}

Table comments {
  comment_id bigint [primary key]
  comment_content text
  likes integer [default: 0]
  posted_at timestamp
  images string[] [null] // link to the position in S3
}

// Closure table
Table parentChildComments {
  parent_comment bigint // FK
  child_comment bigint // FK
}

Table likes {
  like_id bigint [primary key]
  user_id bigint // FK
  comment_id bigint // FK
  post_id bigint // FK
}

Table postsHastags {
  post_id bigint
  tag_id bigint
}

Ref: comments.comment_id < likes.like_id

// In my system it is a separate system
Table hashtags {
  // connected on the application level
  tag_id bigint [primary key]
  tag_name text
}

Ref: comments.comment_id < parentChildComments.parent_comment
Ref: comments.comment_id < parentChildComments.child_comment
Ref: posts.post_id < likes.like_id
Ref: posts.post_id < comments.comment_id

/*
Second system: responsible for users and their relations.
In my system relations is a separate system with graph database
*/

// Relational database example

Table users {
  user_id bigint [primary key]
  name varchar
  surname varchar
  age integer [null]
  phone_number integer [null]
  image string // link to the position in S3
  friends integer [null]
  interests string [null]
  city string [null]
  last_seen timestamp
}

Table relations {
  request_side bigint // FK. It is first side of the relation
  accept_side bigint // FK It is second side of the relation
}

Ref: users.user_id < relations.request_side
Ref: users.user_id < relations.accept_side

// Third microservice: responsible for messages and chats
// Here NoSQL db: MongoDB/Cassandra

// API will accept data with user (author_id)
Table channels {
    channel_id bigint [primary key]
    channel_name string
}

Table messages {
  message_id bigint
  channel_id bigint // FK
  author_id integer // user id
  message_content text
  content_url string[] // link to the position in S3
  sent_at timestamp
}

Table last_seen {
  // table for observing whether there are not read messages
  // connected on the application level
  author_id bigint // user id
  channel_id bigint
  message_id bigint
}

Table last_message {
   // last message in the concrete chat
   // decrease load on read as we have more read in read/write ratio
   // compare from this table to last_seen table
   // connected on the application level
   channel_id bigint
   message_id bigint
}

Ref: channels.channel_id < messages.message_id

// Fourth microservice: responsible for storing Media data (images, video, audio)
Table S3BucketExample {
  SOCIAL_NETWORK_BUCKET object // bucket in S3
  SOCIAL_NETWORK_KEY object // key in the bucket
}
