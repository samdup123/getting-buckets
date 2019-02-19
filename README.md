# getting-buckets
get you some buckets

## Install Lua
```
curl -L http://git.io/lenv | perl
```

and then adding:

```source ~/.lenvrc```

to .bash_profile (Mac OS X) or .bashrc (Ubuntu).

This will let you install many versions of Lua side-by-side. Full documentation is available at the lenv project page, but this will install lua 5.3, luarocks for 5.3, the busted test framework, and the luacov coverage tool:

```lenv fetch
lenv install 5.3.5
lenv use 5.3.5
luarocks install busted
```

## Install Love2d
go to https://love2d.org/


## Install Zenhub (software to help with agile development process)
go to https://www.zenhub.com/extension

## Development Workflow
The goal for development is write code that satisfies unit tests. We will use the busted test framework. Download instructions are above. 


```
+-------------------------------------------------------------------------------+              +-----------------------+
|                                                                               |              |                       |
|  Restaurant                                                                   |              | Table                 |
|                                                                               |     uses     |                       |
+-------------------------------------------------------------------------------+     +------> +-----------------------+
|                                                                               |     |        |                       |
|  - tables : Table[]                                                           +-----+        | - int SeatingCapacity |
|                                                                               |              |                       |
|  - timeItTakesToCleanTable : int                                              |              +-----------------------+
|                                                                               |
|  - openingTime : Time                                                         |              +-----------------+
|                                                                               |              |                 |
|  - closingTime : Time                                                         |              | Time            |
|                                                                               |   uses       |                 |
|  - reservations : Reservation{}                                               +------------> +-----------------+
|                                                                               |              |                 |
+-------------------------------------------------------------------------------+              | - hour : int    |
|                                                                               |              |                 |
|  + CheckIfReservationIsValid(res : Reservaton) : bool                         |              | - minutes : int |
|                                                                               |              |                 |
|  + MakeReservation(res : Reservation) : ResId                                 |              | - day : int     |
|                                                                               |              |                 |
|  + ListAvailableTablesAt(startTime : Time, endTime : Time) : tables : Table[] |              | - month : int   |
|                                                                               |              |                 |
|  + CancelReservation(resUd : ResId) : void                                    |              | - year : int    |
|                                                                               |              |                 |
+----------------------------------------------+--------------------------------+              +-----------------+
                                               |
                                               |                                                           ^
                                               |                     +------------------------+            |
                                               |                     |                        |            |
                                               |                     | Reservation            |            |
                                               |                     |                        |            |
                                               +-------------------> +------------------------+            |
                                                      uses           |                        |   uses     |
                                                                     | - resId : ResId        +------------+
                                                                     |                        |
                                                                     | - startTime : Time     |        +------------+
                                                                     |                        |        |            |
                                                                     | - endTime : Time       +------> | ResId      |
                                                                     |                        | uses   |            |
                                                                     | - tableNum : int       |        +------------+
                                                                     |                        |        |            |
                                                                     | - numberOfPeople : int |        | - uuid int |
                                                                     |                        |        |            |
                                                                     +------------------------+        +------------+

```
