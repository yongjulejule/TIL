# redis-cache-for-wordpress

wordpress는 유저가 페이지에 접속할때마다 MYSQL 쿼리를 쏴서 데이터를 받아오는 식인데, 매번 이런식으로 접근하는건 퍼포먼스 저하가 있음.

redis-cache를 설정하면, 유저가 처음 접속할때 MYSQL에서 데이터를 받아오고, 이후에 접속할땐 redis를 이용해서 더 빠른 접근이 가능함.



[redis-cache-for-wordpress](https://scalegrid.io/blog/using-redis-object-cache-to-speed-up-your-wordpress-installation/#:~:text=How%20Does%20Redis%20Caching%20Work,to%20query%20the%20database%20again.)

[how-redis-works](https://www.section.io/engineering-education/how-to-set-up-and-configure-redis-caching-for-wordpress/#how-redis-works)