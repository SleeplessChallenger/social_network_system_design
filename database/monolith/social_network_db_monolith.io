// Social network diagram

// It is a an overall example if we have a monolith with all data within it.
// Here I use relational database like PostgreSQL

Table users {
  user_id integer [primary key]
  name varchar
  surname varchar
  age integer [null]
  phone_number integer [null]
  image string // link to the position in S3
  friends integer [null]
  interests string [null]
  city string [null]
}

Table posts {
  post_id integer [primary key]
  body text
  author_id integer
  date_added timestamp
  image string [null] // link to the position in S3
  likes integer [default: 0]
  views integer [default: 0] // Ideally, also create a table to track who has seen the post
  hashtags integer [null]
  comments integer [null]
}

Table likes {
  like_id integer [primary key]
  user_id integer // foreign key
  post_comment_id integer // foreign key
}

Table hashtags {
  tag_id integer [primary key]
  tag_name text
}

// Join table for Many-To-Many relationship between Posts, HashTags, Comments
// https://stackoverflow.com/a/24800716/16543524
Table tagPostCommentRelation {
  tag_id integer
  post_id integer
  comment_id integer
}

// Join table for Many-To-Many relationship between Posts, Comments, Users
// https://nehajirafe.medium.com/data-modeling-designing-facebook-style-comments-with-sql-4cf9e81eb164
Table userPostCommentRelation {
  user_id integer
  post_id integer
  comment_id integer
}

Table comments {
  comment_id integer [primary key]
  comment_content text
  likes integer [default: 0]
  posted_at timestamp
  image string [null] // link to the position in S3
}

// Closure table
Table parentChildComments {
  parent_comment integer // FK
  child_comment integer // FK
}


// Post > User: Many-To-One
// Post <> Hashtags: Many-To-Many
// Post < Comments: One-To-Many
// User < Comments: One-To-Many
// Comment < HashTags: One-To-Many
// CommentParent < CommentChild: One-To-Many

Ref: posts.post_id < tagPostCommentRelation.post_id
Ref: hashtags.tag_id < tagPostCommentRelation.tag_id
Ref: comments.comment_id < tagPostCommentRelation.comment_id

Ref: users.user_id < userPostCommentRelation.user_id
Ref: posts.post_id < userPostCommentRelation.post_id
Ref: comments.comment_id < userPostCommentRelation.comment_id

Ref: comments.comment_id < parentChildComments.parent_comment
Ref: comments.comment_id < parentChildComments.child_comment

Ref: posts.likes < likes.post_comment_id
Ref: users.user_id < likes.user_id
Ref: comments.comment_id < likes.post_comment_id


Table messages {
  message_id bigint
  channel_id bigint
  author_id integer // user id
  message_content text
  content_url string // link to the position in S3
  sent_at timestamp
  seen boolean
  message_id_channel_id bigint [primary key] // composite PK
}

Ref: users.user_id < messages.message_id


Table relations {
  request_side integer // FK. It is first side of the relation
  accept_side integer // FK It is second side of the relation
}

Ref: users.user_id < relations.request_side
Ref: users.user_id < relations.accept_side

// S3 buckets

Table S3BucketExample {
  SOCIAL_NETWORK_BUCKET object // bucket in S3
  SOCIAL_NETWORK_KEY object // key in the bucket
}