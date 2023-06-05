### Specs for replication/sharding/partitioning

* _Partitioning_: keep old data/cold data on **HDD** and new/hot data on **SSD**
  * I.e. `messages` table: partition by `sent_at`
  * I.e. `posts` table partition by `date_added`

* _Sharding_:
  * First chunk:
    * `posts`: shard by `post_id`
      * Because some users may make more posts, hence `author_id` is not enough
      * Use **application level sharding** or use ready-made solution like Citus: https://docs.citusdata.com/en/v11.3/get_started/what_is_citus.html#what-is-citus
  * Second chunk:
    * `users`: shard by `user_id`
      * Sharding by `city` is bad as system may have more users from big cities => hot shard
  * Third chunk:
    * `messages`: shard by `channel_id`
      * Sharding by `author_id` is bad as some users are more active => hot shard
      * Additionally, we can put **smart sharding service** for re-balancing data and so on

* _Replication_:
  * type: **master-slave** (one master, 3 slaves)
  * 1 slave is sync and 2 are async
  * configure **Hot Standy** for removing downtime on write

Plus: **Leader election** for choosing new master if old is down.
  * AFAIK: PostgreSQL doesn't have leader election built in: https://github.com/lightningnetwork/lnd/blob/master/docs/leader_election.md
  * How to make Leader Election in SpringBoot app: https://www.linkedin.com/pulse/manage-database-concurrent-writes-using-leader-election-roussi/?trk=read_related_article-card_title 

=> According to the article, simply use external system: https://martinfowler.com/articles/patterns-of-distributed-systems/leader-follower.html