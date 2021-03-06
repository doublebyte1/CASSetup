// @ File:  sqlctr.h
//
// This file is generated by the description file processor.
// Please do not edit.

#define BUFMGR_OBJECT 0
#define BUF_CACHE_HIT_RATIO 2
#define BUF_AWE_UNMAP_CALLS 4
#define BUF_FREELIST_STALLS 6
#define BUF_BLOCK_WRITES 8
#define BUF_HASHED_PAGE_COUNT 10
#define BUF_LIFE_EXPECTANCY 12
#define BUF_AWE_STOLEN_MAPS 14
#define BUF_AWE_LOOKUP_MAPS 16
#define BUF_STOLEN_PAGE_COUNT 18
#define BUF_CACHE_RATIO_BASE 20
#define BUF_NUM_FREE_BUFFERS 22
#define BUF_CHECKPOINT_WRITES 24
#define BUF_COMMITTED_PAGE_COUNT 26
#define BUF_LAZY_WRITES 28
#define BUF_BLOCK_READS 30
#define BUF_RESERVED_PAGE_COUNT 32
#define BUF_READAHEAD_PAGES 34
#define BUF_TARGET_PAGE_COUNT 36
#define BUF_PAGE_REQUESTS 38
#define BUF_AWE_UNMAP_PAGES 40
#define BUF_AWE_WRITE_MAPS 42

#define BUFPART_OBJECT 44
#define BUFPART_FREE_BUFFERS_EMPTY 46
#define BUFPART_FREE_BUFFERS_USED 48
#define BUFPART_NUM_FREE_BUFFERS 50

#define BUFNODE_OBJECT 52
#define BUFNODE_LIFE_EXPECTANCY 54
#define BUFNODE_TARGET_PAGE_COUNT 56
#define BUFNODE_STOLEN_PAGE_COUNT 58
#define BUFNODE_COMMITTED_PAGE_COUNT 60
#define BUFNODE_HASHED_PAGE_COUNT 62
#define BUFNODE_NUM_FREE_BUFFERS 64
#define BUFNODE_FOREIGN_PAGE_COUNT 66

#define GENERAL_OBJECT 68
#define GO_MARS_DEADLOCKS_DETECTED 70
#define GO_SOAP_SESSION_INITIATES 72
#define GO_TRACE_EVT_NOTIF_QUEUE_SIZE 74
#define GO_SOAP_SESSION_TERMINATES 76
#define GO_USER_CONNECTIONS 78
#define GO_USERS_BLOCKED 80
#define GO_HTTP_AUTH_REQS 82
#define GO_TEMP_TABLES_CREATION_RATE 84
#define GO_TRANSACTIONS 86
#define GO_TEMP_TABLES_IN_USE 88
#define GO_TEMP_TABLES_FOR_DESTRUCTION 90
#define GO_LOGICAL_CONNECTIONS 92
#define GO_TRACE_IO_PROVIDER_EVENTLOCK 94
#define GO_NON_ATOMIC_YIELD_RATE 96
#define GO_SOAP_EMPTY_REQS 98
#define GO_LOGINS 100
#define GO_SOAP_WSDL_REQS 102
#define GO_SOAP_QUERY_REQS 104
#define GO_SOAP_SP_REQS 106
#define GO_LOGOUTS 108
#define GO_EVT_NOTIF_DELAYED_DROP 110

#define LOCKS_OBJECT 112
#define LCK_NUM_REQUESTS 114
#define LCK_NUM_TIMEOUTS 116
#define LCK_NUM_TIMEOUTS_NONPROBE 118
#define LCK_TOTAL_WAITTIME 120
#define LCK_NUM_DEADLOCKS 122
#define LCK_AVERAGE_WAITTIME_BASE 124
#define LCK_NUM_WAITS 126
#define LCK_AVERAGE_WAITTIME 128

#define DBMGR_OBJECT 130
#define DB_ACT_XTRAN 132
#define DB_FLUSH_WAIT_TIME 134
#define DB_LOGCACHE_RATIO 136
#define DB_FLUSH_WAITS 138
#define DB_LOG_USED 140
#define DB_LOGCACHE_READS 142
#define DB_DBCC_MOVERATE 144
#define DB_BYTES_FLUSHED 146
#define DB_LOG_USED_PERCENT 148
#define DB_BULK_ROWS 150
#define DB_FLUSHES 152
#define DB_LOG_GROWTHS 154
#define DB_LOG_TRUNCS 156
#define DB_DBCC_SCANRATE 158
#define DB_LOG_SIZE 160
#define DB_BULK_KILOBYTES 162
#define DB_TOTAL_XTRAN 164
#define DB_DATA_SIZE 166
#define DB_REPLCOUNT 168
#define DB_LOG_SHRINKS 170
#define DB_REPLTRANS 172
#define DB_BCK_DB_THROUGHPUT 174
#define DB_LOGCACHE_BASE 176

#define DBMIRRORING_OBJECT 178
#define DB_DBM_BYTES_RECEIVED 180
#define DB_DBMIRRORING_SENDS 182
#define DB_DBM_ACK_TIME 184
#define DB_DBM_REDO_DELTA 186
#define DB_DBMIRRORING_TRANSACTION_DELAY 188
#define DB_DBM_LOG_BYTES_RECEIVED 190
#define DB_DBM_LOG_SEND_QUEUE 192
#define DB_DBMIRRORING_BYTES_SENT 194
#define DB_DBM_LOG_BYTES_SENT 196
#define DB_DBM_RECEIVES 198
#define DB_DBMIRRORING_PAGES_SENT 200
#define DB_DBM_REDO_RATE 202

#define LATCH_OBJECT 204
#define LATCH_WAITS_NP 206
#define LATCH_DEMOTIONS 208
#define LATCH_TOTAL_WAIT_NP 210
#define LATCH_AVG_WAIT_BASE 212
#define LATCH_PROMOTIONS 214
#define LATCH_SUPERLATCHES 216
#define LATCH_AVG_WAIT_NP 218

#define ACCESS_METHODS_OBJECT 220
#define LEAF_PAGE_COOKIE_FAIL 222
#define AM_GHOSTED_SKIPS 224
#define AM_SCAN_REPOSITION 226
#define AM_DEFDROPPEDROWSETSCLEANED 228
#define AM_LOBSS_LOBHANDLES_CREATED 230
#define AM_ORPHANS_CREATED 232
#define AM_PROBE_SCAN 234
#define AM_LOB_READAHEAD_ISSUED 236
#define TREE_PAGE_COOKIE_SUCCEED 238
#define AM_WORKTABLES_FROM_CACHE_BASE 240
#define AM_EXTENTS_ALLOCATED 242
#define AM_COLS_PUSHED_OFFROW 244
#define AM_DDALLOCUNITBATCHESCOMPLETED 246
#define AM_WORKTABLES_FROM_CACHE 248
#define AM_RANGE_SCAN 250
#define AM_COLS_PULLED_INROW 252
#define AM_DDALLOCUNITBATCHESFAILED 254
#define AM_FREESPACE_SCANS 256
#define TREE_PAGE_COOKIE_FAIL 258
#define AM_PAGE_DEALLOCS 260
#define AM_FULL_SCAN 262
#define AM_LOCKESCALATIONS 264
#define AM_FORWARDED_RECS 266
#define AM_ORPHANS_INSERTED 268
#define AM_DEFDROPPEDROWSETQUEUELENGTH 270
#define AM_PAGE_SPLITS 272
#define AM_LOBSS_PROVIDERS_TRUNCATED 274
#define AM_DEFDROPPEDROWSETSSKIPPED 276
#define LEAF_PAGE_COOKIE_SUCCEED 278
#define AM_FREESPACE_PAGES 280
#define AM_DDALLOCUNITQUEUELENGTH 282
#define AM_PAGES_ALLOCATED 284
#define AM_LOBSS_PROVIDERS_CREATED 286
#define AM_WORKFILES_CREATED 288
#define AM_EXTENTS_DEALLOCATED 290
#define AM_LOBSS_LOBHANDLES_DESTROYED 292
#define AM_INDEX_SEARCHES 294
#define AM_DDALLOCUNITSCLEANED 296
#define AM_SINGLE_PAGE_ALLOCS 298
#define AM_WORKTABLES_CREATED 300
#define AM_LOBSS_PROVIDERS_DESTROYED 302

#define SQL_ERROR_OBJECT 304
#define SQL_ERROR_RATE 306

#define SQL_OBJECT 308
#define SQL_AUTOPARAM_FAIL 310
#define SQL_BATCH_REQ 312
#define SQL_AUTOPARAM_UNSAFE 314
#define SQL_ATTENTION_RATE 316
#define SQL_RECOMPILES 318
#define SQL_UNIVPARAM 320
#define SQL_COMPILES 322
#define SQL_AUTOPARAM_SAFE 324
#define SQL_AUTOPARAM_REQ 326

#define PLAN_CACHE 328
#define PLAN_CACHE_OBJECT_COUNT 330
#define PLAN_CACHE_HIT_RATIO_BASE 332
#define PLAN_CACHE_PGS_IN_USE 334
#define PLAN_CACHE_HIT_RATIO 336
#define PLAN_CACHE_USE_COUNT 338

#define CURSOR_OBJECT_BY_TYPE 340
#define CURSOR_MEMORY_USAGE 342
#define CURSOR_CACHE_HIT_RATIO 344
#define CURSOR_CACHE_USE_COUNT 346
#define CURSOR_PLANS 348
#define CURSOR_CACHE_COUNT 350
#define CURSOR_REQ 352
#define CURSOR_CACHE_HIT_RATIO_BASE 354
#define CURSOR_WORKTABLE_USAGE 356
#define CURSOR_IN_USE 358

#define CURSOR_OBJECT_TOTAL 360
#define CURSOR_CONVERSION_RATE 362
#define CURSOR_XSTMT_FLUSH 364
#define CURSOR_ASYNC_POPULATION 366

#define MEMORY_OBJECT 368
#define MEMORY_SERVER_MEMORY 370
#define MEMORY_SQL_CACHE_MEMORY 372
#define MEMORY_MEMGRANT_MAXIMUM 374
#define MEMORY_LOCKS 376
#define MEMORY_MEMGRANT_WAITERS 378
#define MEMORY_LOCKOWNERS 380
#define MEMORY_LOCK_MEMORY 382
#define MEMORY_SERVER_MEMORY_TARGET 384
#define MEMORY_CONNECTION_MEMORY 386
#define MEMORY_LOCKS_ALLOCATED 388
#define MEMORY_OPTIMIZER_MEMORY 390
#define MEMORY_LOCKOWNERS_ALLOCATED 392
#define MEMORY_MEMGRANT_ACQUIRES 394
#define MEMORY_MEMGRANT_OUTSTANDING 396

#define USER_QUERY_OBJECT 398
#define QUERY_INSTANCE 400

#define REPLICATION_AGENT_OBJECT 402
#define RUNNING_INSTANCE 404

#define MERGE_AGENT_OBJECT 406
#define UPLOAD_INSTANCE 408
#define MERGE_CONFLICTS_INSTANCE 410
#define DOWNLOAD_INSTANCE 412

#define LOGREADER_AGENT_OBJECT 414
#define LOGREADER_COMMANDS_INSTANCE 416
#define LOGREADER_LATENCY_INSTANCE 418
#define LOGREADER_TRANSACTIONS_INSTANCE 420

#define DISTRIBUTION_AGENT_OBJECT 422
#define DISTRIBUTION_TRANS_INSTANCE 424
#define DISTRIBUTION_COMMANDS_INSTANCE 426
#define DISTRIBUTION_LATENCY_INSTANCE 428

#define SNAPSHOT_AGENT_OBJECT 430
#define SNAPSHOT_TRANSACTIONS_BCPED 432
#define SNAPSHOT_COMMANDS_BCPED 434

#define BACKUP_DEV_OBJECT 436
#define DB_BCK_DEV_THROUGHPUT 438

#define XACT_OBJECT 440
#define XACT_VER_STORE_SIZE 442
#define XACT_LONGEST_RUNNING 444
#define XACT_NUM 446
#define XACT_VER_STORE_UNIT_TRUNCATION 448
#define XACT_NSNP_VER_NUM 450
#define XACT_SNP_NUM 452
#define XACT_UPD_SNP_NUM 454
#define XACT_VER_STORE_UNIT_COUNT 456
#define XACT_VER_STORE_UNIT_CREATION 458
#define XACT_VER_STORE_GEN_RATE 460
#define XACT_VER_STORE_CLEANUP_RATE 462
#define XACT_TEMPDB_FREE_SPACE 464
#define XACT_UPD_CONFLICTS_RATIO 466
#define XACT_UPD_CONFLICTS_RATIO_BASE 468

#define BROKER_OBJECT 470
#define BO_FORWARDED_MSG_BYTE_RATE 472
#define BO_FORWARDED_PENDING_MSGS 474
#define BO_ENQUEUED_TRANSPORT_FRAG_RATE 476
#define BO_TOTAL_RECEIVES 478
#define BO_ENQUEUED_TRANSPORT_MSG_RATE 480
#define BO_TOTAL_SENDS 482
#define BO_RECEIVE_RATE 484
#define BO_ENQUEUED_TRANSPORT_FRAGS_TOT 486
#define BO_ENQUEUED_MSGS_TOTAL 488
#define BO_ENQUEUED_LOCAL_MSGS_TOTAL 490
#define BO_XACT_ROLLBACKS 492
#define BO_FORWARDED_MSG_TOTAL 494
#define BO_FORWARDED_PENDING_MSG_BYTES 496
#define BO_FORWARDED_MSG_RATE 498
#define BO_ENQUEUED_LOCAL_MSG_RATE 500
#define BO_ENQUEUED_MSG_RATE 502
#define BO_SEND_RATE 504
#define BO_FORWARDED_DISCARDED_MSG_TOTAL 506
#define BO_DEP_TIMER_EVENTS 508
#define BO_FORWARDED_DISCARDED_MSG_RATE 510
#define BO_FORWARDED_MSG_BYTE_TOTAL 512
#define BO_ENQUEUED_TRANSPORT_MSGS_TOTAL 514

#define BROKER_TRANSPORT_OBJECT 516
#define BTO_RECV_IO_PEND_BYTES 518
#define BTO_RECV_FRAG_SIZE_AVG 520
#define BTO_SEND_IO_CURR_FRAG_COUNT 522
#define BTO_RECV_FRAG_SIZE_AVG_BASE 524
#define BTO_RECEIVE_FRAG_RATE 526
#define BTO_SEND_FRAG_RATE 528
#define BTO_SEND_IO_RATE 530
#define BTO_RECEIVE_IO_BYTE_RATE 532
#define BTO_SEND_IO_CURR_BYTES 534
#define BTO_SEND_IO_LEN_AVG 536
#define BTO_SEND_FRAG_SIZE_AVG 538
#define BTO_OPEN_CONNECTIONS 540
#define BTO_RECV_IO_PEND_FRAG_COUNT 542
#define BTO_SEND_IO_BYTE_RATE 544
#define BTO_RECEIVE_IO_RATE 546
#define BTO_RECV_IO_COMPACT_MFB 548
#define BTO_SEND_IO_PEND_BYTES 550
#define BTO_RECV_IO_LEN_AVG 552
#define BTO_RECV_IO_COMPACT_MFB_RATE 554
#define BTO_SEND_IO_LEN_AVG_BASE 556
#define BTO_SEND_IO_PEND_FRAG_COUNT 558
#define BTO_SEND_FRAG_SIZE_AVG_BASE 560
#define BTO_RECV_IO_LEN_AVG_BASE 562
#define BTO_RECV_IO_CURR_BYTES 564

#define BROKER_ACTIVATION_OBJECT 566
#define BAO_TASK_LIMIT_RATE 568
#define BAO_TASK_LIMIT_REACHED 570
#define BAO_TASKS_RUNNING 572
#define BAO_SP_INVOKE_RATE 574
#define BAO_TASK_ABORT_RATE 576
#define BAO_TASK_START_RATE 578

#define WAITSTATS_OBJECT 580
#define WAITSTATS_XACTWORKSPACE 582
#define WAITSTATS_NPAGELATCH 584
#define WAITSTATS_PAGELATCH 586
#define WAITSTATS_MEMTHREAD 588
#define WAITSTATS_PAGEIOLATCH 590
#define WAITSTATS_SOS_WORKER 592
#define WAITSTATS_WRITELOG 594
#define WAITSTATS_TRANSACTION 596
#define WAITSTATS_LOCKS 598
#define WAITSTATS_NETWORKIO 600
#define WAITSTATS_RESOURCE 602
#define WAITSTATS_LOGBUFFER 604

#define EXECSTATS_OBJECT 606
#define EXECSTATS_OLEDB 608
#define EXECSTATS_DQ 610
#define EXECSTATS_DTC 612
#define EXECSTATS_MSQL_XP 614

#define SQLCLR_OBJECT 616
#define SQLCLR_TOTAL_EXECTIME 618

#define METADATAMGR_OBJECT 620
#define MD_CACHE_ENTRY_COUNT 622
#define MD_CACHE_HIT_RATIO 624
#define MD_CACHE_HIT_RATIO_BASE 626
#define MD_CACHE_PINNED_COUNT 628
