create or replace package pe_kafka
is

  -- API keys.
  ak_rq_produce constant pls_integer := 0;
  ak_rq_fetch constant pls_integer := 1;
  ak_rq_list_offset constant pls_integer := 2;
  ak_rq_metadata constant pls_integer := 3;
  ak_rq_leader_and_isr constant pls_integer := 4;
  ak_rq_stop_replica constant pls_integer := 5;
  ak_rq_update_metadata constant pls_integer := 6;
  ak_rq_controlled_shutdown constant pls_integer := 7;
  ak_rq_offset_commit constant pls_integer := 8;
  ak_rq_offset_fetch constant pls_integer := 9;
  ak_rq_find_coordinator constant pls_integer := 10;
  ak_rq_join_group constant pls_integer := 11;
  ak_rq_heartbeat constant pls_integer := 12;
  ak_rq_leave_group constant pls_integer := 13;
  ak_rq_sync_group constant pls_integer := 14;
  ak_rq_describe_groups constant pls_integer := 15;
  ak_rq_list_groups constant pls_integer := 16;
  ak_rq_sasl_handshake constant pls_integer := 17;
  ak_rq_api_versions constant pls_integer := 18;
  ak_rq_create_topics constant pls_integer := 19;
  ak_rq_delete_topics constant pls_integer := 20;
  ak_rq_delete_records constant pls_integer := 21;
  ak_rq_init_producer_id constant pls_integer := 22;
  ak_rq_offset_for_leader_epoch constant pls_integer := 23;
  ak_rq_add_partitions_to_txn constant pls_integer := 24;
  ak_rq_add_offsets_to_txn constant pls_integer := 25;
  ak_rq_end_txn constant pls_integer := 26;
  ak_rq_write_txn_markers constant pls_integer := 27;
  ak_rq_txn_offset_commit constant pls_integer := 28;
  ak_rq_describe_acls constant pls_integer := 29;
  ak_rq_create_acls constant pls_integer := 30;
  ak_rq_delete_acls constant pls_integer := 31;
  ak_rq_describe_configs constant pls_integer := 32;
  ak_rq_alter_configs constant pls_integer := 33;
  ak_rq_alter_replica_log_dirs constant pls_integer := 34;
  ak_rq_describe_log_dirs constant pls_integer := 35;
  ak_rq_sasl_authenticate constant pls_integer := 36;
  ak_rq_create_partitions constant pls_integer := 37;
  ak_rq_create_delegation_token constant pls_integer := 38;
  ak_rq_renew_delegation_token constant pls_integer := 39;
  ak_rq_expire_delegation_token constant pls_integer := 40;
  ak_rq_describe_delegation_token constant pls_integer := 41;
  ak_rq_delete_groups constant pls_integer := 42;
  ak_rq_elect_preferred_leaders constant pls_integer := 43;
  ak_rq_incremental_alter_configs constant pls_integer := 44;
  

  -- Compression types.
  compression_none constant pls_integer := 0;
  compression_gzip constant pls_integer := 1;
  compression_snappy constant pls_integer := 2;
  compression_lz4 constant pls_integer := 3;
  compression_zstd constant pls_integer := 4;
  
  -- Timestamp types.
  timestamp_none constant pls_integer := -1;
  timestamp_create constant pls_integer := 0;
  timestamp_log_append constant pls_integer := 1;
  
  -- Int types.
  c_varint constant pls_integer := 0;
  c_8bit constant pls_integer := 1;
  c_16bit constant pls_integer := 2;
  c_32bit constant pls_integer := 4;
  c_64bit constant pls_integer := 8;
  
  -- Error codes.
  
  -- An unexpected server error.
  unknown exception; 
  pragma exception_init(unknown, -21000);
  
  -- The requested offset is outside the range of offsets maintained by the server
  -- for the given topic/partition.
  offset_out_of_range exception; 
  pragma exception_init(offset_out_of_range, -21001);
  
  -- This indicates that a message contents does not match its CRC.
  corrupt_message exception;
  pragma exception_init(corrupt_message, -21002);
    
  -- This request is for a topic or partition that does not exist on this broker.
  unknown_topic_or_partition exception;
  pragma exception_init(unknown_topic_or_partition, -21003);
  
  -- The message has a negative size.
  invalid_message_size exception;
  pragma exception_init(invalid_message_size, -21004);
  
  -- This error is thrown if we are in the middle of a leadership election and 
  -- there is currently no leader for this partition and hence it is unavailable for writes.
  leader_not_available exception; 
  pragma exception_init(leader_not_available, -21005);
  
  -- This error is thrown if the client attempts to send messages to a replica 
  -- that is not the leader for some partition. It indicates that the clients metadata is out of date.
  not_leader_for_partition exception;                                       
  pragma exception_init(not_leader_for_partition, -21006);
  
  -- This error is thrown if the request exceeds the user-specified time limit in the request.
  request_timed_out exception; 
  pragma exception_init(request_timed_out, -21007);
  
  -- This is not a client facing error and is used mostly by tools when a broker is not alive.
  broker_unavailable exception; 
  pragma exception_init(broker_unavailable, -21008);
  
  -- If replica is expected on a broker, but is not (this can be safely ignored).
  replica_unavailable exception;
  pragma exception_init(replica_unavailable, -21009);
  
  -- The server has a configurable maximum message size to avoid unbounded memory allocation. 
  -- This error is thrown if the client attempt to produce a message larger than this maximum.
  message_size_too_large exception;
  pragma exception_init(message_size_too_large, -21010);
  
  -- Internal error code for broker-to-broker communication.
  stale_controller_epoch exception; 
  pragma exception_init(stale_controller_epoch, -21011);
  
  -- If you specify a string larger than configured maximum for offset metadata.
  offset_metadata_too_large exception;
  pragma exception_init(offset_metadata_too_large, -21012);
  
  -- The broker returns this error code for an offset fetch request if it is still loading offsets 
  -- (after a leader change for that offsets topic partition), or in response to group membership 
  -- requests (such as heartbeats) when group metadata is being loaded by the coordinator.
  group_load_in_progress exception; 
  pragma exception_init(group_load_in_progress, -21014);
  
  -- The broker returns this error code for group coordinator requests, offset commits,
  -- and most group management requests if the offsets topic has not yet been created, 
  -- or if the group coordinator is not active.
  group_coordinator_unavailable exception; 
  pragma exception_init(group_coordinator_unavailable, -21015);
  
  -- The broker returns this error code if it receives an offset fetch or commit request 
  -- for a group that it is not a coordinator for.
  not_coordinator_for_group exception;                                      
  pragma exception_init(not_coordinator_for_group, -21016);
  
  -- For a request which attempts to access an invalid topic (e.g. one which has an illegal name), or 
  -- if an attempt is made to write to an internal topic (such as the consumer offsets topic).
  invalid_topic exception;
  pragma exception_init(invalid_topic, -21017);
  
  -- If a message batch in a produce request exceeds the maximum configured segment size.
  record_list_too_large exception; 
  pragma exception_init(record_list_too_large, -21018);
  
  -- Returned from a produce request when the number of in-sync replicas is lower than the 
  -- configured minimum and requiredAcks is -1.
  not_enough_replicas exception;                                
  pragma exception_init(not_enough_replicas, -21019);
  
  -- Returned from a produce request when the message was written to the log, 
  -- but with fewer in-sync replicas than required.
  not_enough_replicas_on_append exception; 
  pragma exception_init(not_enough_replicas_on_append, -21020);
  
  -- Returned from a produce request if the requested requiredAcks is invalid (anything other than -1, 1, or 0).
  invalid_required_acks exception; 
  pragma exception_init(invalid_required_acks, -21021);
  
  -- Returned from group membership requests (such as heartbeats) when the generation id provided 
  -- in the request is not the current generation.
  illegal_generation exception; 
  pragma exception_init(illegal_generation, -21022);
  
  -- Returned in join group when the member provides a protocol type or set of protocols
  -- which is not compatible with the current group.
  inconsistent_group_protocol exception;
  pragma exception_init(inconsistent_group_protocol, -21023);
  
  -- Returned in join group when the groupId is empty or null.
  invalid_group_id exception;
  pragma exception_init(invalid_group_id, -21024);
  
  -- Returned from group requests (offset commits/fetches, heartbeats, etc) when the memberId 
  -- is not in the current generation.
  unknown_member_id exception;
  pragma exception_init(unknown_member_id, -21025);
  
  -- Return in join group when the requested session timeout is outside of the allowed range on the broker.
  invalid_session_timeout exception;
  pragma exception_init(invalid_session_timeout, -21026);
  
  -- Returned in heartbeat requests when the coordinator has begun rebalancing the group. 
  -- This indicates to the client that it should rejoin the group.
  rebalance_in_progress exception;
  pragma exception_init(rebalance_in_progress, -21027);
  
  -- This error indicates that an offset commit was rejected because of oversize metadata.
  invalid_commit_offset_size exception;
  pragma exception_init(invalid_commit_offset_size, -21028);
  
  -- Returned by the broker when the client is not authorized to access the requested topic.
  topic_authorization_failed exception;
  pragma exception_init(topic_authorization_failed, -21029);
  
  -- Returned by the broker when the client is not authorized to access a particular groupId.
  group_authorization_failed exception;
  pragma exception_init(group_authorization_failed, -21030);
  
  -- Returned by the broker when the client is not authorized to use an inter-broker or administrative API.
  cluster_authorization_failed exception;
  pragma exception_init(cluster_authorization_failed, -21031);

  type te_buf is table of raw(32767) index by pls_integer;
  type te_pre_buf is varray(12) of raw(32767);
  type te_output_buf is record(len integer, -- Размер буфера.
                               idx pls_integer, -- Идентификатор элемента буфера.
                               subpos pls_integer, -- Позиция в элементе буфера.
                               buf te_buf, -- Данные буфера.
                               pre_len pls_integer, -- Размер пребуфера.
                               pre_idx pls_integer, -- Идентификатор элемента буфера.
                               pre_buf te_pre_buf); -- Данные пребуфера.
  
  type te_input_buf is record(len integer, -- Размер буфера.
                              idx pls_integer, -- Идентификатор элемента буфера.
                              subpos pls_integer, -- Позиция в элементе буфера.
                              pos integer, -- Позиция в буфере.
                              buf te_buf); -- Данные буфера.
 
  -- Protocol common types.
  subtype cn_int8 is pls_integer;
  subtype cn_int16 is pls_integer;
  subtype cn_int32 is pls_integer;
  subtype cn_int64 is integer;
  subtype cn_varint is pls_integer;
  subtype cn_string is varchar2(32767);
  subtype cn_boolean is boolean;
  subtype cn_data is blob;
  type cn_int32_set is table of cn_int32 index by pls_integer;
  type cn_int64_set is table of cn_int64 index by pls_integer;
  type cn_string_set is table of cn_string index by pls_integer;

  type cn_header is record(correlation_id cn_int32, client_id cn_string);
  type cn_legacy_record#attribute is record(compression_type cn_int8, timestamp_type cn_int8);
  type cn_legacy_record is record(offset cn_int64,
                                  size_ cn_int32,
                                  magic cn_int8,
                                  attribute cn_legacy_record#attribute,
                                  timestamp_ cn_int64,
                                  key cn_data,
                                  value cn_data);
  type cn_legacy_record_set is table of cn_legacy_record index by pls_integer;
  type cn_legacy_record_node_set is table of pls_integer index by pls_integer;
  type cn_legacy_record_tree is table of cn_legacy_record_node_set index by pls_integer;
  type cn_legacy_record_batch is record(record_set cn_legacy_record_set, record_tree cn_legacy_record_tree);


  type cn_record#header is record(key cn_string, value cn_data);
  type cn_record#header_set is table of cn_record#header index by pls_integer;
  type cn_record is record(attributes cn_int8,
                           timestamp_ cn_int64,
                           offset cn_int32,
                           key cn_data,
                           value cn_data,
                           header_set cn_record#header_set);
  
  type cn_record_set is table of cn_record index by pls_integer;
  
  type cn_record_batch#attribute is record(compression_type cn_int8,
                                           timestamp_type cn_int8,
                                           is_transactional boolean,
                                           is_control boolean);
  
  type cn_record_batch is record(first_offset cn_int64,
                                 partition_leader_epoch cn_int32,
                                 magic cn_int8,
                                 crc cn_int32,
                                 attribute cn_record_batch#attribute,
                                 last_offset_delta cn_int32,
                                 base_timestamp cn_int64,
                                 max_timestamp cn_int64,
                                 producer_id cn_int64,
                                 producer_epoch cn_int16,
                                 base_sequence cn_int32,
                                 record_set cn_record_set);
 
  -- # Produce (0)
  type rq_produce#partition is record(partition_id cn_int32,
                                      legacy_record_batch cn_legacy_record_batch,
                                      record_batch cn_record_batch);
  type rq_produce#partition_set is table of rq_produce#partition index by pls_integer;
  type rq_produce#topic is record(topic_name cn_string,
                                  partition_set rq_produce#partition_set);                                    
  type rq_produce#topic_set is table of rq_produce#topic index by pls_integer;
  type rq_produce is record(transactional_id cn_string,
                            required_acks cn_int16,
                            timeout cn_int32,
                            topic_set rq_produce#topic_set);
                                  
  type rs_produce#partition is record(partition_id cn_int32,
                                      error_code cn_int16,
                                      base_offset cn_int64,
                                      log_append_time cn_int64,
                                      log_start_offset cn_int64);
  type rs_produce#partition_set is table of rs_produce#partition index by pls_integer;
  type rs_produce#topic is record(topic_name cn_string,
                                  partition_set rs_produce#partition_set);
  type rs_produce#topic_set is table of rs_produce#topic index by pls_integer;
  type rs_produce is record(topic_set rs_produce#topic_set,
                            throttle_time cn_int32);
                            
  procedure put_rq_produce(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_produce in rq_produce);
  function read_rs_produce(p_buf in out nocopy te_input_buf) return rs_produce;
  
  -- # Fetch (1)
  type rq_fetch#partition is record(partition_id cn_int32,
                                    current_leader_epoch cn_int32,
                                    fetch_offset cn_int64,
                                    log_start_offset cn_int64,
                                    max_bytes cn_int32);
  type rq_fetch#partition_set is table of rq_fetch#partition index by pls_integer;
  type rq_fetch#topic is record(topic_name cn_string,
                                partition_set rq_fetch#partition_set);
  type rq_fetch#topic_set is table of rq_fetch#topic index by pls_integer;
  type rq_fetch#forgotten_topic is record(topic_name cn_string,
                                          forgotten_partition_set cn_int32_set);
  type rq_fetch#forgotten_topic_set is table of rq_fetch#forgotten_topic index by pls_integer;
  type rq_fetch is record(replica_id cn_int32,
                          max_wait_time cn_int32,
                          min_bytes cn_int32,
                          max_bytes cn_int32,
                          isolation_level cn_int8,
                          session_id cn_int32,
                          session_epoch cn_int32,
                          topic_set rq_fetch#topic_set,
                          forgotten_topic_set rq_fetch#forgotten_topic_set,
                          rack_id cn_string);
  
  type rs_fetch#aborted_tx is record(producer_id cn_int64,
                                     first_offset cn_int64);
  type rs_fetch#aborted_tx_set is table of rs_fetch#aborted_tx;
  type rs_fetch#partition is record(partition_id cn_int32,
                                    error_code cn_int16,
                                    hwm_offset cn_int64,
                                    last_stable_offset cn_int64,
                                    log_start_offset cn_int64,
                                    aborted_tx_set rs_fetch#aborted_tx_set,
                                    preferred_read_replica cn_int32,
                                    legacy_record_batch cn_legacy_record_batch,
                                    record_batch cn_record_batch);
  type rs_fetch#partition_set is table of rs_fetch#partition index by pls_integer;
  type rs_fetch#topic is record(topic_name cn_string,
                                partition_set rs_fetch#partition_set);
  type rs_fetch#topic_set is table of rs_fetch#topic index by pls_integer;
  type rs_fetch is record(throttle_time cn_int32,
                          error_code cn_int16,
                          session_id cn_int32,
                          topic_set rs_fetch#topic_set);
                          
  procedure put_rq_fetch(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_fetch in rq_fetch);
  function read_rs_fetch(p_buf in out nocopy te_input_buf) return rs_fetch;

  -- # List offset (2)
  type rq_list_offset#partition is record(partition_id cn_int32,
                                          current_leader_epoch cn_int32,
                                          timestamp_ cn_int64,
                                          max_offsets cn_int32);
  type rq_list_offset#partition_set is table of rq_list_offset#partition index by pls_integer;
  type rq_list_offset#topic is record(topic_name cn_string,
                                      partition_set rq_list_offset#partition_set);
  type rq_list_offset#topic_set is table of rq_list_offset#topic index by pls_integer;
  type rq_list_offset is record(replica_id cn_int32,
                                isolation_level cn_int8,
                                topic_set rq_list_offset#topic_set);
  
  type rs_list_offset#partition is record(partition_id cn_int32,
                                          error_code cn_int16,
                                          timestamp_ cn_int64,
                                          offset_set cn_int64_set,
                                          offset cn_int64,
                                          leader_epoch cn_int32);
  type rs_list_offset#partition_set is table of rs_list_offset#partition index by pls_integer;
  type rs_list_offset#topic is record(topic_name cn_string,
                                      partition_set rs_list_offset#partition_set);
  type rs_list_offset#topic_set is table of rs_list_offset#topic index by pls_integer;
  type rs_list_offset is record(throttle_time cn_int32,
                                topic_set rs_list_offset#topic_set);
  procedure put_rq_list_offset(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_list_offset in rq_list_offset);
  function read_rs_list_offset(p_buf in out nocopy te_input_buf) return rs_list_offset;
  
    -- # Metadata (3)
  type rq_metadata is record(topic_set cn_string_set,
                             auto_topic_creation cn_boolean,
                             get_cluster_auth_ops cn_boolean,
                             get_topic_auth_ops cn_boolean);

  
  type rs_metadata#partition is record(partition_error_code cn_int16,
                                       partition_id cn_int32,
                                       leader cn_int32,
                                       leader_epoch cn_int32,
                                       replicas cn_int32_set,
                                       isr cn_int32_set,
                                       offline_replicas cn_int32_set);
  type rs_metadata#partition_set is table of rs_metadata#partition index by pls_integer;
  type rs_metadata#topic is record (topic_error_code cn_int16,
                                    topic_name cn_string,
                                    is_internal cn_int16,
                                    partition_set rs_metadata#partition_set,
                                    topic_auth_ops cn_int32);
  type rs_metadata#topic_set is table of rs_metadata#topic index by pls_integer;
  type rs_metadata#broker is record(node_id cn_int32,
                                    host cn_string,
                                    port cn_int32,
                                    rack cn_string);
  type rs_metadata#broker_set is table of rs_metadata#broker index by pls_integer;
  type rs_metadata is record(throttle_time cn_int32,
                             broker_set rs_metadata#broker_set,
                             cluster_id cn_string,
                             controller_id cn_int32,
                             topic_set rs_metadata#topic_set,
                             cluster_auth_ops cn_int32);
                             
  procedure put_rq_metadata(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_metadata in rq_metadata);
  function read_rs_metadata(p_buf in out nocopy te_input_buf) return rs_metadata;
  
  -- # Leader and isr (4)
  type rq_leader_and_isr#live_leader is record(broker_id cn_int32,
                                     host cn_string,
                                     port cn_int32);
  type rq_leader_and_isr#live_leader_set is table of rq_leader_and_isr#live_leader index by pls_integer;
  type rq_leader_and_isr#partition_state is record(topic_name cn_string,
                                                   partition_id cn_int32,
                                                   controller_epoch cn_int32,
                                                   leader_key cn_int32,
                                                   leader_epoch cn_int32,
                                                   isr_replica_set cn_int32_set,
                                                   zk_version cn_int32,
                                                   replica_set cn_int32_set,
                                                   is_new cn_boolean);
  type rq_leader_and_isr#partition_state_set is table of rq_leader_and_isr#partition_state index by pls_integer;
  type rq_leader_and_isr#topic_state is record(topic_name cn_string, partition_state_set rq_leader_and_isr#partition_state_set);
  type rq_leader_and_isr#topic_state_set is table of rq_leader_and_isr#topic_state index by pls_integer;
  type rq_leader_and_isr is record(controller_id cn_int32,
                                   controller_epoch cn_int32,
                                   broker_epoch cn_int64,
                                   partition_state_set rq_leader_and_isr#partition_state_set,
                                   topic_state_set rq_leader_and_isr#topic_state_set,
                                   live_leader_set rq_leader_and_isr#live_leader_set);
  
  type rs_leader_and_isr#partition is record(topic_name cn_string,
                                             partition_id cn_int32,
                                             error_code cn_int16);
  type rs_leader_and_isr#partition_set is table of rs_leader_and_isr#partition index by pls_integer;
  type rs_leader_and_isr is record(error_code cn_int16,
                                   partition_set rs_leader_and_isr#partition_set);
                                   
  procedure put_rq_leader_and_isr(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_leader_and_isr in rq_leader_and_isr);
  function read_rs_leader_and_isr(p_buf in out nocopy te_input_buf) return rs_leader_and_isr;                       
                         
  -- # Stop replica (5)
  type rq_stop_replica#partition is record(topic_name cn_string,
                                           partition_id cn_int32);
  type rq_stop_replica#partition_set is table of rq_stop_replica#partition index by pls_integer;
  type rq_stop_replica#topic is record(topic_name cn_string,
                                       partition_set cn_int32_set);
  type rq_stop_replica#topic_set is table of rq_stop_replica#topic index by pls_integer;
  
  type rq_stop_replica is record(controller_id cn_int32,
                                 controller_epoch cn_int32,
                                 broker_epoch cn_int64,
                                 delete_partition_set cn_boolean,
                                 partition_set rq_stop_replica#partition_set,
                                 topic_set rq_stop_replica#topic_set);
                    
  
  type rs_stop_replica#partition is record(topic_name cn_string,
                                           partition_id cn_int32,
                                           error_code cn_int16);
  type rs_stop_replica#partition_set is table of rs_stop_replica#partition index by pls_integer;
  type rs_stop_replica is record(error_code cn_int16,
                                 partition_set rs_stop_replica#partition_set);
                                 
  procedure put_rq_stop_replica(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_stop_replica in rq_stop_replica);
  function read_rs_stop_replica(p_buf in out nocopy te_input_buf) return rs_stop_replica;
                           
  -- # Update metadata (6)
  type rq_update_metadata#partition_state is record(topic_name cn_string,
                                                    partition_id cn_int32,
                                                    controller_epoch cn_int32,
                                                    leader cn_int32,
                                                    leader_epoch cn_int32,
                                                    isr cn_int32_set,
                                                    zk_version cn_int32,
                                                    replica_set cn_int32_set,
                                                    offline_replica_set cn_int32_set);  
  type rq_update_metadata#partition_state_set is table of rq_update_metadata#partition_state index by pls_integer;
  type rq_update_metadata#topic_state is record(topic_name cn_string, partition_state_set rq_update_metadata#partition_state_set);
  type rq_update_metadata#topic_state_set is table of rq_update_metadata#topic_state index by pls_integer;
  type rq_update_metadata#endpoint is record(port cn_int32,
                                             host cn_string,
                                             listener cn_string,
                                             security_protocol cn_int16);
  type rq_update_metadata#endpoint_set is table of rq_update_metadata#endpoint index by pls_integer;
  type rq_update_metadata#broker is record(id cn_int32,
                                           host cn_string,
                                           port cn_int32,
                                           endpoint_set rq_update_metadata#endpoint_set,
                                           rack cn_string);
  type rq_update_metadata#broker_set is table of rq_update_metadata#broker index by pls_integer;
  type rq_update_metadata is record(controller_id cn_int32,
                                    controller_epoch cn_int32,
                                    broker_epoch cn_int64,
                                    partition_state_set rq_update_metadata#partition_state_set,
                                    topic_state_set rq_update_metadata#topic_state_set,
                                    broker_set rq_update_metadata#broker_set);
                         
  type rs_update_metadata is record(error_code cn_int16);
                    
  procedure put_rq_update_metadata(p_buf in out nocopy te_output_buf, p_rq_update_metadata in rq_update_metadata);
  function read_rs_update_metadata(p_buf in out nocopy te_input_buf) return rs_update_metadata;
  
  -- # Controlled shutdown (7)
  
  type rq_controlled_shutdown is record(broker_id cn_int32,
                                        broker_epoch cn_int64);
                      
  type rs_controlled_shutdown#remaining_partition is record(topic_name cn_string,
                                                            partition_id cn_int32);
  type rs_controlled_shutdown#remaining_partition_set is table of rs_controlled_shutdown#remaining_partition index by pls_integer;   
  type rs_controlled_shutdown is record(error_code cn_int16,
                                        remaining_partition_set rs_controlled_shutdown#remaining_partition_set);
                                        
  procedure put_rq_controlled_shutdown(p_buf in out nocopy te_output_buf, p_rq_controlled_shutdown in rq_controlled_shutdown);
  function read_rs_controlled_shutdown(p_buf in out nocopy te_input_buf) return rs_controlled_shutdown;
  
  -- # Offset commit (8)
  type rq_offset_commit#partition is record(partition_id cn_int32,
                                            offset cn_int64,
                                            timestamp_ cn_int64,
                                            leader_epoch cn_int32,
                                            metadata cn_string);
  type rq_offset_commit#partition_set is table of rq_offset_commit#partition index by pls_integer;
  type rq_offset_commit#topic is record(topic_name cn_string,
                                        partition_set rq_offset_commit#partition_set);
  type rq_offset_commit#topic_set is table of rq_offset_commit#topic index by pls_integer;
  type rq_offset_commit is record(group_id cn_string,
                                  generation_id cn_int32,
                                  member_id cn_string,
                                  retention_time cn_int64,
                                  group_instance_id cn_string,
                                  topic_set rq_offset_commit#topic_set);
  
  type rs_offset_commit#partition is record(partition_id cn_int32,
                                            error_code cn_int16);
  type rs_offset_commit#partition_set is table of rs_offset_commit#partition index by pls_integer;                                  
  type rs_offset_commit#topic is record(topic_name cn_string,
                                        partition_set rs_offset_commit#partition_set);
  type rs_offset_commit#topic_set is table of rs_offset_commit#topic index by pls_integer;
  type rs_offset_commit is record(throttle_time cn_int32,
                                  topic_set rs_offset_commit#topic_set);
                                  
  procedure put_rq_offset_commit(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_offset_commit in rq_offset_commit);
  function read_rs_offset_commit(p_buf in out nocopy te_input_buf) return rs_offset_commit;
  
  -- # Offset fetch (9)
  type rq_offset_fetch#topic is record(topic_name cn_string,
                                       partition_set cn_int32_set);
  type rq_offset_fetch#topic_set is table of rq_offset_fetch#topic index by pls_integer;
  type rq_offset_fetch is record(group_id cn_string,
                                 topic_set rq_offset_fetch#topic_set);
  
  type rs_offset_fetch#partition is record(partition_id cn_int32,
                                           offset cn_int64,
                                           committed_leader_epoch cn_int32,
                                           metadata cn_string,
                                           error_code cn_int16);
  type rs_offset_fetch#partition_set is table of rs_offset_fetch#partition index by pls_integer;
  type rs_offset_fetch#topic is record(topic_name cn_string,
                                       partition_set rs_offset_fetch#partition_set);
  type rs_offset_fetch#topic_set is table of rs_offset_fetch#topic index by pls_integer;
  type rs_offset_fetch is record(throttle_time cn_int32,
                                 topic_set rs_offset_fetch#topic_set,
                                 error_code cn_int16);
                                 
  procedure put_rq_offset_fetch(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_offset_fetch in rq_offset_fetch);
  function read_rs_offset_fetch(p_buf in out nocopy te_input_buf) return rs_offset_fetch;
  
  -- # Find coordinator (10)
  type rq_find_coordinator is record(key cn_string,
                                     key_type cn_int8);
  
  type rs_find_coordinator is record(throttle_time cn_int32,
                                     error_code cn_int16,
                                     error_message cn_string,
                                     node_id cn_int32,
                                     host cn_string,
                                     port cn_int32);
                                     
  procedure put_rq_find_coordinator(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_find_coordinator in rq_find_coordinator);
  function read_rs_find_coordinator(p_buf in out nocopy te_input_buf) return rs_find_coordinator;
  
  -- # Join group (11)
  type rq_join_group#protocol is record(name cn_string,
                                        metadata cn_data);
  type rq_join_group#protocol_set is table of rq_join_group#protocol index by pls_integer;
  type rq_join_group is record(group_id cn_string,
                               session_timeout cn_int32,
                               rebalance_timeout cn_int32,
                               member_id cn_string,
                               instance_id cn_string,
                               protocol_type cn_string,
                               protocol_set rq_join_group#protocol_set);
  
  type rs_join_group#member is record(member_id cn_string,
                                      instance_id cn_string,
                                      metadata cn_data);
  type rs_join_group#member_set is table of rs_join_group#member;
  type rs_join_group is record(throttle_time cn_int32,
                               error_code cn_int16,
                               generation_id cn_int32,
                               protocol_name cn_string,
                               leader_id cn_string,
                               member_id cn_string,
                               member_set rs_join_group#member_set);
                               
  procedure put_rq_join_group(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_join_group in rq_join_group);
  function read_rs_join_group(p_buf in out nocopy te_input_buf) return rs_join_group;
  
  -- # Heartbeat (12)
  type rq_heartbeat is record(group_id cn_string,
                              generation_id cn_int32,
                              member_id cn_string,
                              instance_id cn_string);
                              
  type rs_heartbeat is record(throttle_time cn_int32,
                              error_code cn_int16);
  
  procedure put_rq_heartbeat(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_heartbeat in rq_heartbeat);
  function read_rs_heartbeat(p_buf in out nocopy te_input_buf) return rs_heartbeat;
  
  -- # Leave group (13)
  type rq_leave_group is record(group_id cn_string,
                                member_id cn_string);
                                
  type rs_leave_group is record(throttle_time cn_int32,
                                error_code cn_int16);
  
  procedure put_rq_leave_group(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_leave_group in rq_leave_group);
  function read_rs_leave_group(p_buf in out nocopy te_input_buf) return rs_leave_group;
  
  -- # Sync group (14)
  type rq_sync_group#assignment is record(member_id cn_string,
                                          assignment cn_data);
  type rq_sync_group#assignment_set is table of rq_sync_group#assignment index by pls_integer;
  type rq_sync_group is record(group_id cn_string,
                               generation_id cn_int32,
                               member_id cn_string,
                               instance_id cn_string,
                               assignment_set rq_sync_group#assignment_set);
                               
  type rs_sync_group is record(throttle_time cn_int32,
                               error_code cn_int16,
                               assignment cn_data);
  
  procedure put_rq_sync_group(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_sync_group in rq_sync_group);
  function read_rs_sync_group(p_buf in out nocopy te_input_buf) return rs_sync_group;
  
  -- # Describe groups (15)
  type rq_describe_groups is record(group_set cn_string_set,
                                    include_authorized_operations boolean);
  
  type rs_describe_groups#member is record(member_id cn_string,
                                           client_id cn_string,
                                           client_host cn_string,
                                           member_metadata cn_data,
                                           member_assignment cn_data);
  type rs_describe_groups#member_set is table of rs_describe_groups#member index by pls_integer;
  type rs_describe_groups#group is record(error_code cn_int16,  
                                          group_id cn_string,
                                          group_state cn_string,
                                          protocol_type cn_string,
                                          protocol_data cn_string,
                                          member_set rs_describe_groups#member_set,
                                          authorized_operations cn_int32);
  type rs_describe_groups#group_set is table of rs_describe_groups#group index by pls_integer;
  type rs_describe_groups is record(throttle_time cn_int32,
                                    group_set rs_describe_groups#group_set);
  
  procedure put_rq_describe_groups(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_groups in rq_describe_groups);
  function read_rs_describe_groups#member(p_buf in out nocopy te_input_buf) return rs_describe_groups#member;
  
  -- # List groups (16)
  type rs_list_groups#group is record(group_id cn_string, protocol_type cn_string);
  type rs_list_groups#group_set is table of rs_list_groups#group index by pls_integer;
  type rs_list_groups is record(throttle_time cn_int32,
                                error_code cn_int16,
                                group_set rs_list_groups#group_set);
  
  procedure put_rq_list_groups(p_buf in out nocopy te_output_buf, p_rq_header in cn_header);
  function read_rs_list_groups(p_buf in out nocopy te_input_buf) return rs_list_groups;
                                   
  -- # Sasl handshake (17)
  type rq_sasl_handshake is record(mechanism cn_string);
  
  type rs_sasl_handshake is record(error_code cn_int16,
                                   mechanism_set cn_string_set);
  
  procedure put_rq_sasl_handshake(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_sasl_handshake in rq_sasl_handshake);
  function read_rs_sasl_handshake(p_buf in out nocopy te_input_buf) return rs_sasl_handshake;
  
  -- # Api versions (18)
  type rs_api_versions#api_key is record(id cn_int16,
                                         min_version cn_int16,
                                         max_version cn_int16);
  type rs_api_versions#api_key_set is table of rs_api_versions#api_key index by pls_integer;
  type rs_api_versions is record(error_code cn_int16,
                                 api_key_set rs_api_versions#api_key_set,
                                 throttle_time cn_int32);
  
  procedure put_rq_api_versions(p_buf in out nocopy te_output_buf, p_rq_header in cn_header);
  function read_rs_api_versions(p_buf in out nocopy te_input_buf) return rs_api_versions;
  
  -- # Create topics (19)
  type rq_create_topics#assignment is record(partition_id cn_int32,
                                             broker_id_set cn_int32_set);
  type rq_create_topics#assignment_set is table of rq_create_topics#assignment index by pls_integer;
  type rq_create_topics#config is record(name cn_string,
                                         value cn_string);
  type rq_create_topics#config_set is table of rq_create_topics#config index by pls_integer;
  type rq_create_topics#topic is record(name cn_string,
                                        partition_count cn_int32,
                                        replication_factor cn_int16,
                                        assignment_set rq_create_topics#assignment_set,
                                        config_set rq_create_topics#config_set);
  type rq_create_topics#topic_set is table of rq_create_topics#topic index by pls_integer;
  type rq_create_topics is record(topic_set rq_create_topics#topic_set,
                                  timeout cn_int32,
                                  validate_only cn_boolean);
  
  type rs_create_topics#topic is record(name cn_string,
                                        error_code cn_int16,
                                        error_message cn_string);
  type rs_create_topics#topic_set is table of rs_create_topics#topic index by pls_integer;
  type rs_create_topics is record(throttle_time cn_int32,
                                  topic_set rs_create_topics#topic_set);
  
  procedure put_rq_create_topics(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_create_topics in rq_create_topics);
  function read_rs_create_topics(p_buf in out nocopy te_input_buf) return rs_create_topics;
  
  -- # Delete topics (20)
  type rq_delete_topics is record(topic_name_set cn_string_set,
                                  timeout cn_int32);
                         
  type rs_delete_topics#response is record(name cn_string,
                                           error_code cn_int16);
  type rs_delete_topics#response_set is table of rs_delete_topics#response index by pls_integer;
  type rs_delete_topics is record(throttle_time cn_int32,
                                  response_set rs_delete_topics#response_set);
  
  procedure put_rq_delete_topics(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_delete_topics in rq_delete_topics);
  function read_rs_delete_topics(p_buf in out nocopy te_input_buf) return rs_delete_topics;
  
  -- # Delete records (21)
  type rq_delete_records#partition is record(partition_id cn_int32,
                                             offset cn_int64);
  type rq_delete_records#partition_set is table of rq_delete_records#partition index by pls_integer;
  type rq_delete_records#topic is record(name cn_string,
                                         partition_set rq_delete_records#partition_set);  
  type rq_delete_records#topic_set is table of rq_delete_records#topic index by pls_integer;
  type rq_delete_records is record(topic_set rq_delete_records#topic_set,
                                   timeout cn_int32);
                         
  type rs_delete_records#partition is record(partition_id cn_int32,
                                             low_watermark cn_int64,
                                             error_code cn_int16);
  type rs_delete_records#partition_set is table of rs_delete_records#partition index by pls_integer;
  type rs_delete_records#topic is record(name cn_string,
                                         partition_set rs_delete_records#partition_set);
  type rs_delete_records#topic_set is table of rs_delete_records#topic index by pls_integer;
  type rs_delete_records is record(throttle_time cn_int32,
                                   topic_set rs_delete_records#topic_set);
  
  procedure put_rq_delete_records(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_delete_records in rq_delete_records);
  function read_rs_delete_records(p_buf in out nocopy te_input_buf) return rs_delete_records;
  
  -- # Init producer id (22)
  type rq_init_producer_id is record(transactional_id cn_string,
                                     transaction_timeout cn_int32);
  
  type rs_init_producer_id is record(throttle_time cn_int32,
                                     error_code cn_int16,
                                     producer_id cn_int64,
                                     producer_epoch cn_int16);
  
  procedure put_rq_init_producer_id(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_init_producer_id in rq_init_producer_id);
  function read_rs_init_producer_id(p_buf in out nocopy te_input_buf) return rs_init_producer_id;
                                       
  -- # Offset for leader epoch (23)
  type rq_offset_for_leader_epoch#partition is record(partition_id cn_int32,
                                                      current_leader_epoch cn_int32,
                                                      leader_epoch cn_int32);
  type rq_offset_for_leader_epoch#partition_set is table of rq_offset_for_leader_epoch#partition index by pls_integer;
  type rq_offset_for_leader_epoch#topic is record(name cn_string,
                                                  partition_set rq_offset_for_leader_epoch#partition_set);
  type rq_offset_for_leader_epoch#topic_set is table of rq_offset_for_leader_epoch#topic index by pls_integer;
  type rq_offset_for_leader_epoch is record(replica_id cn_int32,
                                            topic_set rq_offset_for_leader_epoch#topic_set);
  
  type rs_offset_for_leader_epoch#partition is record(error_code cn_int16,
                                                      partition_id cn_int32,
                                                      leader_epoch cn_int32,
                                                      end_offset cn_int64);
  type rs_offset_for_leader_epoch#partition_set is table of rs_offset_for_leader_epoch#partition index by pls_integer;
  type rs_offset_for_leader_epoch#topic is record(name cn_string,
                                                  partition_set rs_offset_for_leader_epoch#partition_set);
  type rs_offset_for_leader_epoch#topic_set is table of rs_offset_for_leader_epoch#topic index by pls_integer;
  type rs_offset_for_leader_epoch is record(throttle_time cn_int32,
                                            topic_set rs_offset_for_leader_epoch#topic_set);
  
  procedure put_rq_offset_for_leader_epoch(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_offset_for_leader_epoch in rq_offset_for_leader_epoch);
  function read_rs_offset_for_leader_epoch(p_buf in out nocopy te_input_buf) return rs_offset_for_leader_epoch;
  
  -- # Add partitions to txn (24)
  type rq_add_partitions_to_txn#topic is record(name cn_string,
                                                partition_set cn_int32_set);
  type rq_add_partitions_to_txn#topic_set is table of rq_add_partitions_to_txn#topic index by pls_integer;
  type rq_add_partitions_to_txn is record(transactional_id cn_string,
                                          producer_id cn_int64,
                                          producer_epoch cn_int16,
                                          topic_set rq_add_partitions_to_txn#topic_set);
  
  type rs_add_partitions_to_txn#partition_result is record(partition_id cn_int32,
                                                           error_code cn_int16);
  type rs_add_partitions_to_txn#partition_result_set is table of rs_add_partitions_to_txn#partition_result index by pls_integer;
  type rs_add_partitions_to_txn#result is record(name cn_string,
                                                 partition_result_set rs_add_partitions_to_txn#partition_result_set);
  type rs_add_partitions_to_txn#result_set is table of rs_add_partitions_to_txn#result index by pls_integer;
  type rs_add_partitions_to_txn is record(throttle_time cn_int32,
                                          result_set rs_add_partitions_to_txn#result_set);
  
  procedure put_rq_add_partitions_to_txn(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_add_partitions_to_txn in rq_add_partitions_to_txn);
  function read_rs_add_partitions_to_txn(p_buf in out nocopy te_input_buf) return rs_add_partitions_to_txn;
  
  
  -- # Add offsets to txn (25)
  type rq_add_offsets_to_txn is record(transactional_id cn_string,
                                       producer_id cn_int64,
                                       producer_epoch cn_int16,
                                       group_id cn_string);
  
  type rs_add_offsets_to_txn is record(throttle_time cn_int32,
                                       error_code cn_int16);
  
  procedure put_rq_add_offsets_to_txn(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_add_offsets_to_txn in rq_add_offsets_to_txn);
  function read_rs_add_offsets_to_txn(p_buf in out nocopy te_input_buf) return rs_add_offsets_to_txn;
                                       
  -- # End txn (26)
  type rq_end_txn is record(transactional_id cn_string,
                            producer_id cn_int64,
                            producer_epoch cn_int16,
                            commited cn_boolean);
  
  type rs_end_txn is record(throttle_time cn_int32,
                            error_code cn_int16);
  
  procedure put_rq_end_txn(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_end_txn in rq_end_txn);
  function read_rs_end_txn(p_buf in out nocopy te_input_buf) return rs_end_txn;
                              
  -- # Write txn markers (27)
  type rq_write_txn_markers#topic is record(name cn_string,
                                            partition_set cn_int32_set);
  type rq_write_txn_markers#topic_set is table of rq_write_txn_markers#topic index by pls_integer;
  type rq_write_txn_markers#marker is record(producer_id cn_int64,
                                             producer_epoch cn_int16,
                                             transaction_result cn_boolean,
                                             topic_set rq_write_txn_markers#topic_set,
                                             coordinator_epoch cn_int32);
  type rq_write_txn_markers#marker_set is table of rq_write_txn_markers#marker index by pls_integer;
  type rq_write_txn_markers is record(marker_set rq_write_txn_markers#marker_set);
  
  type rs_write_txn_markers#partition is record(partition_id cn_int32,
                                                error_code cn_int16);
  type rs_write_txn_markers#partition_set is table of rs_write_txn_markers#partition index by pls_integer;
  type rs_write_txn_markers#topic is record(name cn_string,
                                            partition_set rs_write_txn_markers#partition_set);
  type rs_write_txn_markers#topic_set is table of rs_write_txn_markers#topic index by pls_integer;
  type rs_write_txn_markers#marker is record(producer_id cn_int64,
                                             topic_set rs_write_txn_markers#topic_set);
  type rs_write_txn_markers#marker_set is table of rs_write_txn_markers#marker index by pls_integer;
  type rs_write_txn_markers is record(marker_set rs_write_txn_markers#marker_set);
  
  procedure put_rq_write_txn_markers(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_write_txn_markers in rq_write_txn_markers);
  function read_rs_write_txn_markers(p_buf in out nocopy te_input_buf) return rs_write_txn_markers;
  
  -- # Txn offset commit (28)
  type rq_txn_offset_commit#partition is record(partition_id cn_int32,
                                                committed_offset cn_int64,
                                                committed_leader_epoch cn_int32,
                                                committed_metadata cn_string);
  type rq_txn_offset_commit#partition_set is table of rq_txn_offset_commit#partition index by pls_integer;
  type rq_txn_offset_commit#topic is record(name cn_string,
                                            partition_set rq_txn_offset_commit#partition_set);
  type rq_txn_offset_commit#topic_set is table of rq_txn_offset_commit#topic index by pls_integer;
  type rq_txn_offset_commit is record(transactional_id cn_string,
                                      group_id cn_string,
                                      producer_id cn_int64,
                                      producer_epoch cn_int16,
                                      topic_set rq_txn_offset_commit#topic_set);
  
  type rs_txn_offset_commit#partition is record(partition_id cn_int32,
                                                error_code cn_int16);
  type rs_txn_offset_commit#partition_set is table of rs_txn_offset_commit#partition index by pls_integer;                                      
  type rs_txn_offset_commit#topic is record(name cn_string,
                                            partition_set rs_txn_offset_commit#partition_set);
  type rs_txn_offset_commit#topic_set is table of rs_txn_offset_commit#topic index by pls_integer;
  type rs_txn_offset_commit is record(throttle_time cn_int32,
                                      topic_set rs_txn_offset_commit#topic_set);
  
  procedure put_rq_txn_offset_commit(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_txn_offset_commit in rq_txn_offset_commit);
  function read_rs_txn_offset_commit(p_buf in out nocopy te_input_buf) return rs_txn_offset_commit;
  
  -- # Describe acls (29)
  type rq_describe_acls is record(resource_type cn_int8,
                                  resource_name_filter cn_string,
                                  resource_pattern_type cn_int8,
                                  principal_filter cn_string,
                                  host_filter cn_string,
                                  operation cn_int8,
                                  permission_type cn_int8);
  
  type rs_describe_acls#acl is record(principal cn_string,
                                      host cn_string,
                                      operation cn_int8,
                                      permission_type cn_int8);
  type rs_describe_acls#acl_set is table of rs_describe_acls#acl index by pls_integer;
  type rs_describe_acls#resource is record(type cn_int8,
                                           name cn_string,
                                           pattern_type cn_int8,
                                           acl_set rs_describe_acls#acl_set);
  type rs_describe_acls#resource_set is table of rs_describe_acls#resource index by pls_integer;
  type rs_describe_acls is record(throttle_time cn_int32,
                                  error_code cn_int16,
                                  error_message cn_string,
                                  resource_set rs_describe_acls#resource_set);
  
  procedure put_rq_describe_acls(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_acls in rq_describe_acls);
  function read_rs_describe_acls(p_buf in out nocopy te_input_buf) return rs_describe_acls;
  
  -- # Create acls (30)
  type rq_create_acls#creation is record(resource_type cn_int8,
                                         resource_name cn_string,
                                         resource_pattern_type cn_int8,
                                         principal cn_string,
                                         host cn_string,
                                         operation cn_int8,
                                         permission_type cn_int8);
  type rq_create_acls#creation_set is table of rq_create_acls#creation index by pls_integer;
  type rq_create_acls is record(creation_set rq_create_acls#creation_set);
  
  type rs_create_acls#result is record(error_code cn_int16,
                                       error_message cn_string);
  type rs_create_acls#result_set is table of rs_create_acls#result index by pls_integer;
  type rs_create_acls is record(throttle_time cn_int32,
                                result_set rs_create_acls#result_set);
  
  procedure put_rq_create_acls(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_create_acls in rq_create_acls);
  function read_rs_create_acls(p_buf in out nocopy te_input_buf) return rs_create_acls;
                                
  -- # Delete acls (31)
  type rq_delete_acls#filter is record(resource_type_filter cn_int8,
                                       resource_name_filter cn_string,
                                       pattern_type_filter cn_int8,
                                       principal_filter cn_string,
                                       host_filter cn_string,
                                       operation cn_int8,
                                       permission_type cn_int8);
  type rq_delete_acls#filter_set is table of rq_delete_acls#filter index by pls_integer;
  type rq_delete_acls is record(filter_set rq_delete_acls#filter_set);
  
  type rs_delete_acls#acl is record(error_code cn_int16,
                                    error_message cn_string,
                                    resource_type cn_int8,
                                    resource_name cn_string,
                                    pattern_type cn_int8,
                                    principal cn_string,
                                    host cn_string,
                                    operation cn_int8,
                                    permission_type cn_int8);
  type rs_delete_acls#acl_set is table of rs_delete_acls#acl index by pls_integer;
  type rs_delete_acls#result is record(error_code cn_int16,
                                       error_message cn_string,
                                       matching_acl_set rs_delete_acls#acl_set);
  type rs_delete_acls#result_set is table of rs_delete_acls#result index by pls_integer;
  type rs_delete_acls is record(throttle_time cn_int32,
                                filter_result_set rs_delete_acls#result_set);
  
  procedure put_rq_delete_acls(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_delete_acls in rq_delete_acls);
  function read_rs_delete_acls(p_buf in out nocopy te_input_buf) return rs_delete_acls;
  
  -- # Describe configs (32)
  type rq_describe_configs#resource is record(resource_type cn_int8,
                                              resource_name cn_string,
                                              configuration_key_set cn_string_set);
  type rq_describe_configs#resource_set is table of rq_describe_configs#resource index by pls_integer;
  type rq_describe_configs is record(resource_set rq_describe_configs#resource_set,
                                     include_synonyms cn_boolean);
  
  type rs_describe_configs#synonym is record(name cn_string,
                                            value cn_string,
                                            source cn_int8);
  type rs_describe_configs#synonym_set is table of rs_describe_configs#synonym index by pls_integer;
  type rs_describe_configs#config is record(name cn_string,
                                            value cn_string,
                                            read_only cn_boolean,
                                            is_default cn_boolean,
                                            config_source cn_int8,
                                            is_sensitive cn_boolean,
                                            synonym_set rs_describe_configs#synonym_set);
  type rs_describe_configs#config_set is table of rs_describe_configs#config index by pls_integer;
  type rs_describe_configs#result is record(error_code cn_int16,
                                            error_message cn_string,
                                            resource_type cn_int8,
                                            resource_name cn_string,
                                            config_set rs_describe_configs#config_set);
  type rs_describe_configs#result_set is table of rs_describe_configs#result index by pls_integer;
  type rs_describe_configs is record(throttle_time cn_int32,
                                     result_set rs_describe_configs#result_set);
  
  procedure put_rq_describe_configs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_configs in rq_describe_configs);
  function read_rs_describe_configs(p_buf in out nocopy te_input_buf) return rs_describe_configs;
  
  -- # Alter configs (33)
  type rq_alter_configs#config is record(name cn_string,
                                         value cn_string);
  type rq_alter_configs#config_set is table of rq_alter_configs#config index by pls_integer;
  type rq_alter_configs#resource is record(resource_type cn_int8,
                                           resource_name cn_string,
                                           config_set rq_alter_configs#config_set);
  type rq_alter_configs#resource_set is table of rq_alter_configs#resource index by pls_integer;
  type rq_alter_configs is record(resource_set rq_alter_configs#resource_set,
                                  validate_only cn_boolean);
  
  type rs_alter_configs#resource is record(error_code cn_int16,
                                           error_message cn_string,
                                           resource_type cn_int8,
                                           resource_name cn_string);
  type rs_alter_configs#resource_set is table of rs_alter_configs#resource index by pls_integer;
  type rs_alter_configs is record(throttle_time cn_int32,
                                  resource_set rs_alter_configs#resource_set);
  
  procedure put_rq_alter_configs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_alter_configs in rq_alter_configs);
  function read_rs_alter_configs(p_buf in out nocopy te_input_buf) return rs_alter_configs;
  
  -- # Alter replica log dirs (34)
  type rq_alter_replica_log_dirs#topic is record(name cn_string,
                                                 partition_set cn_int32_set);
  type rq_alter_replica_log_dirs#topic_set is table of rq_alter_replica_log_dirs#topic index by pls_integer;
  type rq_alter_replica_log_dirs#dir is record(path cn_string,
                                               topic_set rq_alter_replica_log_dirs#topic_set);
  type rq_alter_replica_log_dirs#dir_set is table of rq_alter_replica_log_dirs#dir index by pls_integer;
  type rq_alter_replica_log_dirs is record(dir_set rq_alter_replica_log_dirs#dir_set);
  
  type rs_alter_replica_log_dirs#partition is record(partition_id cn_int32,
                                                     error_code cn_int16);
  type rs_alter_replica_log_dirs#partition_set is table of rs_alter_replica_log_dirs#partition index by pls_integer;
  type rs_alter_replica_log_dirs#result is record(topic_name cn_string,
                                                  partition_set rs_alter_replica_log_dirs#partition_set);
  type rs_alter_replica_log_dirs#result_set is table of rs_alter_replica_log_dirs#result index by pls_integer;
  type rs_alter_replica_log_dirs is record(throttle_time cn_int32,
                                           result_set rs_alter_replica_log_dirs#result_set);
  
  procedure put_rq_alter_replica_log_dirs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_alter_replica_log_dirs in rq_alter_replica_log_dirs);
  function read_rs_alter_replica_log_dirs(p_buf in out nocopy te_input_buf) return rs_alter_replica_log_dirs;
  
  -- # Describe log dirs (35)
  type rq_describe_log_dirs#topic is record(name cn_string,
                                            partition_set cn_int32_set);
  type rq_describe_log_dirs#topic_set is table of rq_describe_log_dirs#topic index by pls_integer;
  type rq_describe_log_dirs is record(topic_set rq_describe_log_dirs#topic_set);
  
  type rs_describe_log_dirs#partition is record(partition_id cn_int32,
                                                partition_size cn_int64,
                                                offset_lag cn_int64,
                                                is_future_key cn_boolean);
  type rs_describe_log_dirs#partition_set is table of rs_describe_log_dirs#partition index by pls_integer;
  type rs_describe_log_dirs#topic is record(name cn_string,
                                            partition_set rs_describe_log_dirs#partition_set);
  type rs_describe_log_dirs#topic_set is table of rs_describe_log_dirs#topic index by pls_integer;
  type rs_describe_log_dirs#result is record(error_code cn_int16,
                                             log_dir cn_string,
                                             topic_set rs_describe_log_dirs#topic_set);
  type rs_describe_log_dirs#result_set is table of rs_describe_log_dirs#result index by pls_integer;
  type rs_describe_log_dirs is record(throttle_time cn_int32,
                                      result_set rs_describe_log_dirs#result_set);
  
  procedure put_rq_describe_log_dirs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_log_dirs in rq_describe_log_dirs);
  function read_rs_describe_log_dirs(p_buf in out nocopy te_input_buf) return rs_describe_log_dirs;
  
  -- # Sasl authenticate (36)
  type rq_sasl_authenticate is record(auth_bytes cn_data);

  type rs_sasl_authenticate is record(error_code cn_int16,
                                      error_message cn_string,
                                      auth_bytes cn_data,
                                      session_lifetime cn_int64);
  
  procedure put_rq_sasl_authenticate(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_sasl_authenticate in rq_sasl_authenticate);
  function read_rs_sasl_authenticate(p_buf in out nocopy te_input_buf) return rs_sasl_authenticate;
  
  -- # Create partitions (37)
  type rq_create_partitions#assignment is record(broker_set cn_int32_set);
  type rq_create_partitions#assignment_set is table of rq_create_partitions#assignment index by pls_integer;
  type rq_create_partitions#topic is record(name cn_string,
                                            count cn_int32,
                                            assignment_set rq_create_partitions#assignment_set);
  type rq_create_partitions#topic_set is table of rq_create_partitions#topic index by pls_integer;
  type rq_create_partitions is record(topic_set rq_create_partitions#topic_set,
                                      timeout cn_int32,
                                      validate_only cn_boolean);
  
  type rs_create_partitions#result is record(name cn_string,
                                             error_code cn_int16,
                                             error_message cn_string);
  type rs_create_partitions#result_set is table of rs_create_partitions#result index by pls_integer;
  type rs_create_partitions is record(throttle_time cn_int32,
                                      result_set rs_create_partitions#result_set);
  
  procedure put_rq_create_partitions(p_buf in out nocopy te_output_buf, p_rq_create_partitions in rq_create_partitions);
  function read_rs_create_partitions(p_buf in out nocopy te_input_buf) return rs_create_partitions;
  
  -- # Create delegation token (38)
  type rq_create_delegation_token#renewer is record(principal_type cn_string,
                                                    principal_name cn_string);
  type rq_create_delegation_token#renewer_set is table of rq_create_delegation_token#renewer index by pls_integer;
  type rq_create_delegation_token is record(renewer_set rq_create_delegation_token#renewer_set,
                                            max_lifetime cn_int64);
  
  type rs_create_delegation_token is record(error_code cn_int16,
                                            principal_type cn_string,
                                            principal_name cn_string,
                                            issue_timestamp cn_int64,
                                            expiry_timestamp cn_int64,
                                            max_timestamp cn_int64,
                                            token_id cn_string,
                                            hmac cn_data,
                                            throttle_time cn_int32);
                                            
  procedure put_rq_create_delegation_token(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_create_delegation_token in rq_create_delegation_token);
  function read_rs_create_delegation_token(p_buf in out nocopy te_input_buf) return rs_create_delegation_token;
  
  -- # Renew delegation token (39)
  type rq_renew_delegation_token is record(hmac cn_data,
                                           renew_period cn_int64);
  
  type rs_renew_delegation_token is record(error_code cn_int16,
                                           expiry_timestamp cn_int64,
                                           throttle_time cn_int32);
                                           
  procedure put_rq_renew_delegation_token(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_renew_delegation_token in rq_renew_delegation_token);
  function read_rs_renew_delegation_token(p_buf in out nocopy te_input_buf) return rs_renew_delegation_token;
    
  -- # Expire delegation token (40)
  type rq_expire_delegation_token is record(hmac cn_data,
                                            expiry_time_period cn_int64);
  
  type rs_expire_delegation_token is record(error_code cn_int16,
                                            expiry_timestamp cn_int64,
                                            throttle_time cn_int32);
                                            
  procedure put_rq_expire_delegation_token(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_expire_delegation_token in rq_expire_delegation_token);
  function read_rs_expire_delegation_token(p_buf in out nocopy te_input_buf) return rs_expire_delegation_token;
  
  -- # Describe delegation token (41)
  type rq_describe_delegation_token#owner is record(principal_type cn_string,
                                                    principal_name cn_string);
  type rq_describe_delegation_token#owner_set is table of rq_describe_delegation_token#owner index by pls_integer;
  type rq_describe_delegation_token is record(owner_set rq_describe_delegation_token#owner_set);
  
  type rs_describe_delegation_token#renewer is record(principal_type cn_string,
                                                      principal_name cn_string);
  type rs_describe_delegation_token#renewer_set is table of rs_describe_delegation_token#renewer index by pls_integer;
  type rs_describe_delegation_token#token is record(principal_type cn_string,
                                                    principal_name cn_string,
                                                    issue_timestamp cn_int64,
                                                    expiry_timestamp cn_int64,
                                                    max_timestamp cn_int64,
                                                    token_id cn_string,
                                                    hmac cn_data,
                                                    renewer_set rs_describe_delegation_token#renewer_set);
  type rs_describe_delegation_token#token_set is table of rs_describe_delegation_token#token index by pls_integer;
  type rs_describe_delegation_token is record(error_code cn_int16,
                                              token_set rs_describe_delegation_token#token_set,
                                              throttle_time cn_int32);
  
  procedure put_rq_describe_delegation_token(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_delegation_token in rq_describe_delegation_token);
  function read_rs_describe_delegation_token(p_buf in out nocopy te_input_buf) return rs_describe_delegation_token;
  
  -- # Delete groups (42)
  type rq_delete_groups is record(group_name_set cn_string_set);
  
  type rs_delete_groups#result is record(group_id cn_string,
                                         error_code cn_int16);
  type rs_delete_groups#result_set is table of rs_delete_groups#result index by pls_integer;
  type rs_delete_groups is record(throttle_time cn_int32,
                                  result_set rs_delete_groups#result_set);
                                  
  procedure put_rq_delete_groups(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_delete_groups in rq_delete_groups);
  function read_rs_delete_groups(p_buf in out nocopy te_input_buf) return rs_delete_groups;
  
  -- # Elect preferred leaders (43)
  type rq_elect_preferred_leaders#topic_partition is record(topic cn_string,
                                                            partition_set cn_int32_set);
  type rq_elect_preferred_leaders#topic_partition_set is table of rq_elect_preferred_leaders#topic_partition index by pls_integer;
  type rq_elect_preferred_leaders is record(topic_partition_set rq_elect_preferred_leaders#topic_partition_set,
                                            timeout cn_int32);
                                            
  type rs_elect_preferred_leaders#partition_result is record(partition_id cn_int32,
                                                             error_code cn_int16,
                                                             error_message cn_string);
  type rs_elect_preferred_leaders#partition_result_set is table of rs_elect_preferred_leaders#partition_result index by pls_integer;
  type rs_elect_preferred_leaders#result is record(topic cn_string,
                                                   partition_result_set rs_elect_preferred_leaders#partition_result_set);
  type rs_elect_preferred_leaders#result_set is table of rs_elect_preferred_leaders#result index by pls_integer;
  type rs_elect_preferred_leaders is record(throttle_time cn_int32,
                                            result_set rs_elect_preferred_leaders#result_set);
  
  procedure put_rq_elect_preferred_leaders(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_elect_preferred_leaders in rq_elect_preferred_leaders);
  function read_rs_elect_preferred_leaders(p_buf in out nocopy te_input_buf) return rs_elect_preferred_leaders;
  
  -- # Incremental alter configs (44)
  type rq_incremental_alter_configs#config is record(name cn_string,
                                                     config_operation cn_int8,
                                                     value cn_string);
  type rq_incremental_alter_configs#config_set is table of rq_incremental_alter_configs#config index by pls_integer;
  type rq_incremental_alter_configs#resource is record(resource_type cn_int8,
                                                       resource_name cn_string,
                                                       config_set rq_incremental_alter_configs#config_set);
  type rq_incremental_alter_configs#resource_set is table of rq_incremental_alter_configs#resource index by pls_integer;
  type rq_incremental_alter_configs is record(resource_set rq_incremental_alter_configs#resource_set,
                                              validate_only cn_boolean);
  
  type rs_incremental_alter_configs#response is record(error_code cn_int16,
                                                       error_message cn_string,
                                                       resource_type cn_int8,
                                                       resource_name cn_string);
  type rs_incremental_alter_configs#response_set is table of rs_incremental_alter_configs#response index by pls_integer;
  type rs_incremental_alter_configs is record(throttle_time cn_int32,
                                              response_set rs_incremental_alter_configs#response_set);
  
  procedure put_rq_incremental_alter_configs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_incremental_alter_configs in rq_incremental_alter_configs);
  function read_rs_incremental_alter_configs(p_buf in out nocopy te_input_buf) return rs_incremental_alter_configs;
  
  
  
  
  function get_init_output_buf return te_output_buf;
  
  
  function get_database_charset(p_language in varchar2) return varchar2 deterministic parallel_enable;
  
  function get_charset_size(p_charset in varchar2) return pls_integer deterministic parallel_enable;
  
  function to_epoch(p_timestamp in timestamp) return cn_int64 deterministic parallel_enable;
  
  function to_epoch_tz(p_timestamp in timestamp with time zone) return cn_int64 deterministic parallel_enable;
  
  procedure set_api_version(p_val in cn_int8);
  
  function api_key_version(p_ak in pls_integer) return pls_integer;
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  procedure send(p_con in out nocopy utl_tcp.connection,
                 p_correlation_id in cn_int32,
                 p_buf_rq in te_output_buf, 
                 p_buf_rs out nocopy te_input_buf);
  
  /*
  
  function dec_int(p_val in raw, p_len in pls_integer default c_32bit) return cn_int32 deterministic parallel_enable;

  function enc_int(p_val in cn_int32, p_len in pls_integer default c_32bit) return raw deterministic parallel_enable; 

  function dec_varint(p_val in raw) return cn_int32 deterministic parallel_enable;

  function enc_varint(p_val in cn_int32, p_len out nocopy pls_integer) return raw deterministic parallel_enable;  

  function get_varint_size(p_val in cn_int32) return cn_int8 deterministic parallel_enable;
  
  
  
  function compressor_put(p_val in raw, p_type in out nocopy cn_int8, p_flush in boolean default false) return cn_int32;
  
  function compressor_get return raw;
  
  function decompressor_put(p_val in raw, p_type in out nocopy cn_int8, p_flush in boolean default false) return cn_int32;
  
  function decompressor_get return raw;

  */

end;
/
create or replace package body pe_kafka
is

  g_api_version pls_integer := 8;
  
  c_database_language constant varchar2(4000) := sys_context('userenv', 'language');
  c_database_charset constant varchar2(4000) := get_database_charset(c_database_language);
  c_database_charset_size constant pls_integer := get_charset_size(c_database_charset);
  c_database_charset_utf8 constant varchar2(4000) := 'AL32UTF8';
  c_charset_utf8 constant varchar2(64) := 'utf8'; 

  c_epoch constant timestamp := timestamp '1970-01-01 00:00:00';
  
  c_crc32 constant varchar2(6) := 'crc32';
  c_crc32c constant varchar2(6) := 'crc32c';
  

  c_0x00000001 constant pls_integer := 1;
  c_0x00000002 constant pls_integer := 2;
  c_0x00000000 constant pls_integer := 0;
  c_0xffffffff constant pls_integer := -1;
  c_0x80000000 constant simple_integer := -2147483648;
  c_0x7fffffff constant pls_integer := 2147483647;

  c_0x00000080 constant simple_integer := 128;
  c_0x0000007f constant simple_integer := 127;
  c_0x000000ff constant simple_integer := 255;
  
  c_s0x00000000 constant simple_integer := 0;
  
  
  
  c_0x080000000 constant integer := 2147483648;
  c_0x100000000 constant integer := 4294967296;
  c_0x000008000 constant integer := 32768;
  c_0x000000002 constant integer := 2;
  c_0x0000000000 constant integer := 0;
  
  c_0x000010000 constant simple_integer := 65536;
  c_0x000000080 constant simple_integer := 128;
  c_0x000000100 constant simple_integer := 256;

  
  c_0x08000000000000000 constant integer := 9223372036854775808;
  c_0x10000000000000000 constant integer := 18446744073709551616;
  
  -- Степени двойки для кодирования varint.
  type te_varint_t is varray(5) of simple_integer;
  c_varint_t constant te_varint_t := te_varint_t(1, 128, 16384, 2097152, 268435456);
  
  -- Соответствие чисел 0 .. 255 и их бинарного представления для ускорения кодирования varint.
  type te_int8_t is table of raw(1) index by simple_integer;
  g_int8_t te_int8_t;
  
  -- Соответствие шестнадцатиричной строки и чисел 0 .. 255 для ускорения декодирования varint.
  type te_int8_r_t is table of simple_integer index by varchar2(2);
  g_int8_r_t te_int8_r_t;
  
  
  c_size_a constant pls_integer := 32768;
  c_size constant pls_integer := 32767;
  c_char_size constant pls_integer := floor(c_size / c_database_charset_size);
  
  c_zero_byte_buf constant raw(1) := hextoraw('00');
  c_zero_buf constant raw(c_size) := utl_raw.overlay(c_zero_byte_buf, c_zero_byte_buf, 1, c_size);
  c_zero_pre_buf constant te_pre_buf := te_pre_buf(null, null, null, null, null, null, 
                                                   null, null, null, null, null, null);
  
  c_init_output_buf constant te_output_buf := get_init_output_buf();
  
  function get_init_output_buf return te_output_buf
  is
    l_buf te_output_buf;
  begin
    l_buf.len := 0;
    l_buf.idx := c_0x00000000;
    l_buf.subpos := c_0x00000000;
    l_buf.pre_len := c_0x00000000;
    l_buf.pre_idx := c_0x00000000;
    l_buf.pre_buf := c_zero_pre_buf;
    return l_buf;
  end;
  
  procedure throw(p_n in pls_integer, p_message in varchar2)
  is
  begin
    raise_application_error(-20000 - p_n, p_message, true);
  end;
  
  /**
   * Получить кодировку базы данных из переменной language.
   * @param p_language Переменная language.
   * @return Кодировка базы данных.
   */
  function get_database_charset(p_language in varchar2) return varchar2 deterministic parallel_enable
  is
  begin
    return substr(p_language, instr(p_language, '.') + 1);
  end;
  
  /**
   * 
   */
  function get_charset_size(p_charset in varchar2) return pls_integer deterministic parallel_enable
  is
  begin
    return utl_i18n.get_max_character_size(p_charset);
  end;
  
  function to_epoch(p_timestamp in timestamp) return cn_int64 deterministic parallel_enable
  is
    c_int constant interval day(9) to second(9) := p_timestamp - c_epoch;
    l_s pls_integer;
  begin
    l_s := extract(hour from c_int) * 3600 + extract(minute from c_int) * 60 + extract(second from c_int);
    return l_s * 1000 + extract(day from c_int) * 86400000;
  end;
  
  function to_epoch_tz(p_timestamp in timestamp with time zone) return cn_int64 deterministic parallel_enable
  is
  begin
    return to_epoch(sys_extract_utc(p_timestamp));
  end;
  
  /**
   * Установка версии.
   * @param p_val Версия.
   */
  procedure set_api_version(p_val in cn_int8)
  is
  begin
    if p_val is null or not p_val between 0 and 8 then
      throw(3, 'Invalid api version (' || p_val || ').');
    end if;
    g_api_version := p_val;
  end;
  
  /**
   * Получение версии.
   * @return Версия.
   */
  function api_version return pls_integer deterministic
  is
  begin
    return g_api_version;
  end;
  
  function api_key_version(p_ak in pls_integer) return pls_integer
  is
  begin
    return case p_ak
             when ak_rq_produce then 7
             when ak_rq_fetch then 11
             when ak_rq_list_offset then 5
             when ak_rq_metadata then 8
             when ak_rq_leader_and_isr then 2
             when ak_rq_stop_replica then 1
             when ak_rq_update_metadata then 5
             when ak_rq_controlled_shutdown then 2
             when ak_rq_offset_commit then 7
             when ak_rq_offset_fetch then 5
             when ak_rq_find_coordinator then 2
             when ak_rq_join_group then 5
             when ak_rq_heartbeat then 3
             when ak_rq_leave_group then 2
             when ak_rq_sync_group then 3
             when ak_rq_describe_groups then 3
             when ak_rq_list_groups then 2
             when ak_rq_sasl_handshake then 1
             when ak_rq_api_versions then 2
             when ak_rq_create_topics then 3
             when ak_rq_delete_topics then 3
             when ak_rq_delete_records then 1
             when ak_rq_init_producer_id then 1
             when ak_rq_offset_for_leader_epoch then 3
             when ak_rq_add_partitions_to_txn then 1
             when ak_rq_add_offsets_to_txn then 1
             when ak_rq_end_txn then 1
             when ak_rq_write_txn_markers then 0
             when ak_rq_txn_offset_commit then 2
             when ak_rq_describe_acls then 1
             when ak_rq_create_acls then 1
             when ak_rq_delete_acls then 1
             when ak_rq_describe_configs then 2
             when ak_rq_alter_configs then 1
             when ak_rq_alter_replica_log_dirs then 1
             when ak_rq_describe_log_dirs then 1
             when ak_rq_sasl_authenticate then 1
             when ak_rq_create_partitions then 1
             when ak_rq_create_delegation_token then 1
             when ak_rq_renew_delegation_token then 1
             when ak_rq_expire_delegation_token then 1
             when ak_rq_describe_delegation_token then 1
             when ak_rq_delete_groups then 1
             when ak_rq_elect_preferred_leaders then 0
             when ak_rq_incremental_alter_configs then 0
             else null
           end;
  end;
  
  /**
   * Получение целого числа int32 из бинарных данных.
   * @param p_val Бинарные данные.
   * @return Целое число int32.
   */
  function dec_int(p_val in raw, p_len in pls_integer default c_32bit) return cn_int32 deterministic parallel_enable
  is
    l_val integer;
  begin
    l_val := to_number(rawtohex(p_val), 'fmxxxxxxxx');
    if p_len = c_32bit then
      if l_val < c_0x080000000 then
        return l_val;
      else
        return l_val - c_0x100000000;
      end if;
    elsif p_len = c_16bit then
      if l_val < c_0x000008000 then
        return l_val;
      else
        return l_val - c_0x000010000;
      end if;
    elsif p_len = c_8bit then
      if l_val < c_0x000000080 then
        return l_val;
      else
        return l_val - c_0x000000100;
      end if;
    else
      throw(1, 'Wrong input length (' || p_len || ').');
    end if; 
  end;
  
  /**
   * Получение целого числа int32 (varint) из бинарных данных.
   * @param p_val Бинарные данные.
   * @return Целое число int32 (varint).
   */
  function dec_varint(p_val in raw) return cn_int32 deterministic parallel_enable
  is
    l_byte simple_integer := c_s0x00000000;
    l_int integer := c_0x0000000000;
  begin
    for i in 1 .. 5 loop
      l_byte := g_int8_r_t(rawtohex(utl_raw.substr(p_val, i, len => c_0x00000001)));
      if l_byte >= c_0x00000080 then -- Установлен старший бит.
        l_int := l_int + (l_byte - c_0x00000080) * c_varint_t(i);
      else
        l_int := l_int + l_byte * c_varint_t(i);
        if bitand(l_int, c_0x00000001) = c_0x00000001 then
          return -(l_int + c_0x00000001) / c_0x00000002;
        else
          return l_int / c_0x00000002;
        end if;
      end if;
    end loop;
    throw(1, 'Invalid varint number (' || rawtohex(p_val) || ').');
  end;
  
  /**
   * Получение целого числа int64 из бинарных данных.
   * @param p_val Бинарные данные.
   * @return Целое число int64.
   */
  function dec_int64(p_val in raw) return cn_int64 deterministic parallel_enable
  is
    l_val integer;
  begin
    l_val := to_number(rawtohex(p_val), 'fmxxxxxxxxxxxxxxxx');
    if l_val < c_0x08000000000000000 then
      return l_val;
    else
      return l_val - c_0x10000000000000000;
    end if;
  end;
   
  /**
   * Получение строки из бинарных данных.
   * @param p_val Бинарные данные.
   * @return Строка.
   */
  function dec_string(p_val in raw) return cn_string deterministic parallel_enable
  is
  begin
    return utl_i18n.raw_to_char(p_val, c_charset_utf8);
  end;
  
  /**
   * Преобразование целого числа int32.
   * @param p_val Целое число.
   * @param p_len Размер числа байт.
   * @return Бинарные данные.
   */
  function enc_int(p_val in cn_int32, p_len in pls_integer default c_32bit) return raw deterministic parallel_enable
  is
    l_val integer := p_val;
  begin
    if l_val < c_0x00000000 then
      l_val := l_val + case p_len
                         when c_32bit then c_0x100000000
                         when c_16bit then c_0x000010000
                         when c_8bit  then c_0x000000100
                       end;
    end if;
    if p_len = c_32bit then
      return hextoraw(to_char(l_val, 'fm0000000x'));
    elsif p_len = c_16bit then
      return hextoraw(to_char(l_val, 'fm000x'));
    elsif p_len = c_8bit then
      return hextoraw(to_char(l_val, 'fm0x'));
    else
      throw(1, 'Wrong input length (' || p_len || ').');
    end if;
  end;
  
  /**
   * Получение размера varint представления целого числа int32.
   * @param p_val Целое число int32.
   * @return Размер varint представления целого числа int32.
   */
  function get_varint_size(p_val in cn_int32) return cn_int8 deterministic parallel_enable
  is
    c_base constant binary_double := 128d;
    l_val binary_double;
  begin
    if p_val = c_0x00000000 then
      return c_0x00000001;
    elsif p_val > c_0x00000000 then
      l_val := p_val * c_0x00000002 + c_0x00000001;
    else
      l_val := -p_val * c_0x00000002 - c_0x00000001;
    end if;
    return ceil(log(c_base, l_val));
  end;
  
  /**
   * Преобразование целого числа int32 (varint) в бинарные данные.
   * @param p_val Целое число.
   * @param p_len Размер бинарных данных.
   * @return Бинарные данные.
   */
  function enc_varint(p_val in cn_int32, p_len out nocopy pls_integer) return raw deterministic parallel_enable
  is
    l_val integer := p_val;
    l_int simple_integer := c_0x00000000;
    l_buf te_pre_buf := c_zero_pre_buf;
  begin
    if l_val < c_0x00000000 then
      l_val := -l_val * c_0x000000002 - c_0x00000001;
    else
      l_val := l_val * c_0x000000002;
    end if;
    for i in 1 .. 5 loop
      if l_val >= c_0x00000080 then
        l_int := mod(l_val, c_0x00000080);
        l_buf(i) := g_int8_t(l_int + c_0x00000080);
        l_val := (l_val - l_int) / c_0x00000080;
      else
        l_buf(i) := g_int8_t(l_val); p_len := i;
        return utl_raw.concat(l_buf(1), l_buf(2), l_buf(3), l_buf(4), l_buf(5));
      end if;
    end loop;
    raise invalid_number;
  end;
  
  /**
   * Преобразование целого числа int64 в бинарные данные.
   * @param p_val Целое число.
   * @return Бинарные данные.
   */
  function enc_int64(p_val in integer) return raw deterministic parallel_enable
  is
    l_val integer := p_val;
  begin
    if l_val < c_0x00000000 then
      l_val := l_val + c_0x10000000000000000;
    end if;
    return hextoraw(to_char(l_val, 'fm000000000000000x'));
  end;
  
  /**
   * Преобразование строки в бинарные данные.
   * @param p_val строка.
   * @return Бинарные данные.
   */
  function enc_string(p_val in cn_string) return raw deterministic parallel_enable
  is
    l_raw raw(c_size);
  begin
    if not p_val is null then
      if c_database_charset = c_database_charset_utf8 then -- Перекодирование не требуется.
        l_raw := utl_raw.cast_to_raw(p_val);
      else
        l_raw := utl_i18n.string_to_raw(p_val, c_charset_utf8);
      end if;
    end if;
    return l_raw;
  end;
   
  /**
   * Обновление контрольной суммы crc32.
   * @param p_val Бинарные данные.
   * @param p_init Инициализация контрольной суммы.
   */
  procedure crc_update32(p_val in raw, p_init in boolean)
  is
    language java name 'com.github.aig.kafka.crypto.Crc32.update32(byte[], boolean)';
  
  /**
   * Обновление контрольной суммы crc32c.
   * @param p_val Бинарные данные.
   * @param p_init Инициализация контрольной суммы.
   */
  procedure crc_update32c(p_val in raw, p_init in boolean)
  is
    language java name 'com.github.aig.kafka.crypto.Crc32.update32c(byte[], boolean)';
  
  /**
   * Получение контрльной суммы crc32.
   * @return Контрольная сумма crc32.
   */
  function crc32_get return pls_integer
  is
    language java name 'com.github.aig.kafka.crypto.Crc32.getValue() return int';
  
  /**
   * Обновление контрольной суммы crc32(c).
   * @param p_val Бинарные данные.
   * @param p_init Инициализация контрольной суммы.
   * @param p_type Тип алгоритма.
   */
  procedure crc32_update(p_val in raw, p_init in out nocopy boolean, p_type in varchar2 default c_crc32)
  is
  begin
    if p_type = c_crc32 then
      crc_update32(p_val, p_init);
    elsif p_type = c_crc32c then
      crc_update32c(p_val, p_init);
    end if;
    if p_init then
      p_init := false;
    end if;
  end;
  
  /**
   * Инициализация буфера для записи.
   * @param p_buf Буфер.
   */
  procedure buf_init(p_buf in out nocopy te_output_buf)
  is
  begin
    p_buf := c_init_output_buf;
  end;
  
  procedure buf_init(p_buf in out nocopy te_input_buf, p_len in integer default null)
  is
    l_idx pls_integer;
  begin
    p_buf.idx := c_0x00000001;
    p_buf.len := p_len;
    if p_buf.len is null then
      p_buf.len := 0;
      l_idx := p_buf.buf.last;
      if not l_idx is null then
        p_buf.len := c_size * (p_buf.buf.count - c_0x00000001) + utl_raw.length(p_buf.buf(l_idx));
      end if;
    end if;
    p_buf.pos := 1;
    p_buf.subpos := c_0x00000001;
  end;
  
  /**
   * Размер буфера.
   * @return Размер буфера.
   */
  function buf_len(p_buf in out nocopy te_output_buf) return integer
  is
  begin
    return p_buf.len + p_buf.pre_len;
  end;
  
  /**
   * Получить идентификатор элемента буфера и позицию нем.
   * @param p_pos Позиция.
   * @param p_idx Идентификатор элемента буфера.
   * @param p_subpos Позиция в элементе буфера.
   */
  procedure buf_pos(p_pos in integer, p_idx out nocopy pls_integer, p_subpos out nocopy pls_integer)
  is
  begin  
    p_idx := ceil(p_pos / c_size);
    p_subpos := mod(p_pos - 1, c_size) + 1;
  end;
  
  /**
   * Запись пребуфера в буфер.
   * @param p_buf Буфер.
   */
  procedure buf_pre_flush(p_buf in out nocopy te_output_buf)
  is
    l_left pls_integer;
    l_val raw(c_size);
  begin
    if p_buf.pre_len > c_0x00000000 then
      l_left := c_size - p_buf.subpos; -- Свободное место.
      if p_buf.idx = c_0x00000000 then -- Инициализация буфера.
        p_buf.idx := p_buf.idx + c_0x00000001; p_buf.buf(p_buf.idx) := '';
      end if;
      l_val := utl_raw.concat(p_buf.pre_buf(1), p_buf.pre_buf(2), p_buf.pre_buf(3), p_buf.pre_buf(4),  p_buf.pre_buf(5),  p_buf.pre_buf(6),  
                              p_buf.pre_buf(7), p_buf.pre_buf(8), p_buf.pre_buf(9), p_buf.pre_buf(10), p_buf.pre_buf(11), p_buf.pre_buf(12));
      if l_left >= p_buf.pre_len then
        p_buf.buf(p_buf.idx) := utl_raw.concat(p_buf.buf(p_buf.idx), l_val);
        p_buf.subpos := p_buf.subpos + p_buf.pre_len;
      else
        if l_left > c_0x00000000 then
          p_buf.buf(p_buf.idx) := utl_raw.concat(p_buf.buf(p_buf.idx), utl_raw.substr(l_val, c_0x00000001, l_left));
          p_buf.idx := p_buf.idx + c_0x00000001; p_buf.buf(p_buf.idx) := '';
          p_buf.buf(p_buf.idx) := utl_raw.substr(l_val, l_left + c_0x00000001);
        else
          p_buf.idx := p_buf.idx + c_0x00000001; p_buf.buf(p_buf.idx) := '';
          p_buf.buf(p_buf.idx) := l_val;
        end if;
        p_buf.subpos := p_buf.pre_len - l_left;
      end if;
      p_buf.len := p_buf.len + p_buf.pre_len;
      p_buf.pre_buf := c_zero_pre_buf; -- Сброс пребуфера.
      p_buf.pre_idx := c_0x00000000;
      p_buf.pre_len := c_0x00000000;
    end if;
  end;
  
  /**
   * Сдвиг текущей позиции в буфере вперед.
   * @param p_len Размер сдвига.
   */
  procedure read_ahead(p_buf in out nocopy te_input_buf, p_len in pls_integer)
  is
    l_pos_e pls_integer;
  begin
    if p_buf.pos + p_len - c_0x00000001 <= p_buf.len then
      l_pos_e := p_buf.subpos + p_len;
      if l_pos_e <= c_size_a then
        if p_len = c_size then
          p_buf.subpos := c_0x00000001;
          p_buf.idx := p_buf.idx + c_0x00000001;
        else
          p_buf.subpos := p_buf.subpos + p_len;
        end if;
      else
        p_buf.subpos := l_pos_e - c_size;
        p_buf.idx := p_buf.idx + c_0x00000001;
      end if;
    else -- Достигнут конец буфера.
      throw(1, 'The end of the input buffer has been reached.');
    end if;
  end;
  
  procedure read_raw(p_buf in out nocopy te_input_buf, 
                     p_len in pls_integer, 
                     p_val out nocopy raw, 
                     p_pos in integer default null, 
                     p_align in boolean default null, 
                     p_crc in boolean default null)
  is
    l_pos integer;
    l_idx pls_integer;
    l_subpos pls_integer;
    l_pos_e pls_integer;
  begin
    l_pos := coalesce(p_pos, p_buf.pos);
    if l_pos + p_len - c_0x00000001 <= p_buf.len then
      if p_pos is null then -- Чтение по текущему указателю.
        l_idx := p_buf.idx;
        l_subpos := p_buf.subpos;
      else
        buf_pos(l_pos, l_idx, l_subpos);
      end if;
      l_pos_e := l_subpos + p_len;
      if l_pos_e <= c_size_a then
        if p_len = c_size then
          p_val := p_buf.buf(l_idx);
          l_subpos := c_0x00000001;
          l_idx := l_idx + c_0x00000001;
        else
          p_val := utl_raw.substr(p_buf.buf(l_idx), l_subpos, len => p_len);
          l_subpos := l_subpos + p_len;
        end if;
      else
        p_val := utl_raw.substr(p_buf.buf(l_idx), l_subpos);
        if p_align then -- Выравнивание чтения.
          l_subpos := c_0x00000001;
        else
          l_idx := l_idx + c_0x00000001;
          p_val := utl_raw.concat(p_val, utl_raw.substr(p_buf.buf(l_idx), c_0x00000001, len => l_pos_e - c_size_a));
          l_subpos := l_pos_e - c_size;
        end if;
        l_idx := l_idx + c_0x00000001;
      end if;
      if p_pos is null then
        p_buf.idx := l_idx;
        p_buf.subpos := l_subpos;
        p_buf.pos := p_buf.pos + p_len;
      end if;
    else -- Достигнут конец буфера.
      throw(1, 'The end of the input buffer has been reached.');
    end if;
  end;
  
  function read_int(p_buf in out nocopy te_input_buf, p_len in pls_integer, p_pos in pls_integer default null, p_crc in boolean default null) return cn_int32
  is
    l_len pls_integer := p_len;
    l_raw raw(c_32bit);
  begin
    read_raw(p_buf, l_len, l_raw, p_pos => p_pos, p_crc => p_crc);
    return dec_int(l_raw, l_len);
  end;
  
  function read_varint(p_buf in out nocopy te_input_buf, p_len out nocopy pls_integer, p_pos in integer default null, p_crc in boolean default null) return cn_int32
  is
    l_pos integer;
    l_idx pls_integer;
    l_subpos pls_integer;
    l_buf te_pre_buf := c_zero_pre_buf;
    l_byte simple_integer := 0;
    l_int simple_integer := 0;
  begin
    l_pos := coalesce(p_pos, p_buf.pos);
    if l_pos > 0 and l_pos <= p_buf.len then
      if p_pos is null then -- Чтение по текущему указателю.
        l_idx := p_buf.idx;
        l_subpos := p_buf.subpos;
      else
        buf_pos(l_pos, l_idx, l_subpos);
      end if;
      for i in 1 .. 5 loop
        if l_pos <= p_buf.len then
          l_buf(i) := utl_raw.substr(p_buf.buf(l_idx), l_subpos, 1);
          l_byte := g_int8_r_t(rawtohex(l_buf(i)));
          if l_subpos = c_size then
            l_idx := l_idx + 1;
            l_subpos := 1;
          else
            l_subpos := l_subpos + 1;
          end if;
          l_pos := l_pos + 1;
          if l_byte >= c_0x00000080 then -- Установлен старший бит.
            l_int := l_int + (l_byte - c_0x00000080) * c_varint_t(i);
          else
            l_int := l_int + l_byte * c_varint_t(i); p_len := i;
            exit;
          end if;
        else
          if p_pos is null then
            p_buf.pos := l_pos;
            p_buf.idx := l_idx;
            p_buf.subpos := l_subpos;
          end if;
          throw(1, 'The end of the input buffer has been reached.');
        end if;
      end loop;
      if p_pos is null then
        p_buf.pos := l_pos;
        p_buf.idx := l_idx;
        p_buf.subpos := l_subpos;
      end if;
      if l_byte > c_0x00000080 then
        throw(1, 'Invalid varint number.');
      end if;
    else
      throw(1, 'The end of the input buffer has been reached.');
    end if;
    return l_int;
  end;
  
  function read_int64(p_buf in out nocopy te_input_buf, p_pos in pls_integer default null, p_crc in boolean default null) return cn_int64
  is
    l_len pls_integer := c_64bit;
    l_raw raw(c_64bit);
  begin
    read_raw(p_buf, l_len, l_raw, p_pos => p_pos, p_crc => p_crc);
    return dec_int64(l_raw);
  end;
  
  function read_boolean(p_buf in out nocopy te_input_buf, p_pos in pls_integer default null, p_crc in boolean default null) return cn_boolean
  is
  begin
    return read_int(p_buf, c_8bit, p_pos => p_pos, p_crc => p_crc) > 0;
  end;
  
  function read_string(p_buf in out nocopy te_input_buf, 
                       p_len in pls_integer default null, 
                       p_pre_len in pls_integer default c_16bit, 
                       p_pos in pls_integer default null, 
                       p_crc in boolean default null) return cn_string
  is
    l_string_len pls_integer := p_len;
    l_pos pls_integer := p_pos;
    l_varint_len pls_integer;
    l_raw raw(c_size);
    l_val varchar2(c_size);
  begin
    if l_string_len is null then
      if p_pre_len = c_16bit then
        l_string_len := read_int(p_buf, c_16bit, p_pos => l_pos, p_crc => p_crc);
        l_pos := l_pos + c_16bit;
      elsif p_pre_len = c_varint then
        l_string_len := read_varint(p_buf, l_varint_len, p_pos => l_pos, p_crc => p_crc);
        l_pos := l_pos + l_varint_len;
      end if;
    end if;
    if l_string_len > 0 then
      read_raw(p_buf, l_string_len, l_raw, p_pos => l_pos, p_crc => p_crc);
      l_val := dec_string(l_raw);
    end if;
    return l_val;
  end;
  
  function read_data(p_buf in out nocopy te_input_buf, 
                     p_len in pls_integer default null, 
                     p_pre_len in pls_integer default c_32bit, 
                     p_pos in pls_integer default null, 
                     p_crc in boolean default null) return blob
  is
    l_data_len pls_integer := p_len;
    l_pos pls_integer := p_pos;
    l_varint_len pls_integer;
    l_len pls_integer;
    l_raw raw(c_size);
    l_blob blob;
  begin
    if l_data_len is null then
      if p_pre_len = c_32bit then
        l_data_len := read_int(p_buf, c_32bit, p_pos => l_pos, p_crc => p_crc);
        l_pos := l_pos + c_32bit;
      elsif p_pre_len = c_varint then
        l_data_len := read_varint(p_buf, l_varint_len, p_pos => l_pos, p_crc => p_crc);
        l_pos := l_pos + l_varint_len;
      end if;
    end if;
    if l_data_len > 0 then
      dbms_lob.createtemporary(l_blob, true);
      loop
        exit when l_data_len = 0;
        l_len := least(c_size, l_data_len);
        read_raw(p_buf, l_len, l_raw, p_pos => l_pos, p_align => true, p_crc => p_crc);
        if l_len > 0 then
          dbms_lob.writeappend(l_blob, l_len, l_raw);
          l_pos := l_pos + l_len;
          l_data_len := l_data_len - l_len;
        else
          raise no_data_found; -- Поток завершился раньше времени.
        end if;
      end loop;
    end if;
    return l_blob;
  end;
  
  function read_int_set(p_buf in out nocopy te_input_buf, p_len in pls_integer) return cn_int32_set
  is
    l_size pls_integer;
    l_int_set cn_int32_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_int_set(i) := read_int(p_buf, p_len);
    end loop;
    return l_int_set;
  end;
  
  function read_string_set(p_buf in out nocopy te_input_buf, p_pre_len in pls_integer default c_16bit) return cn_string_set
  is
    l_size pls_integer;
    l_string_set cn_string_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_string_set(i) := read_string(p_buf, p_pre_len => p_pre_len);
    end loop;
    return l_string_set;
  end;
  
  function read_int64_set(p_buf in out nocopy te_input_buf) return cn_int64_set
  is
    l_size pls_integer;
    l_int64_set cn_int64_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_int64_set(i) := read_int64(p_buf);
    end loop;
    return l_int64_set;
  end;
  
  function decompressor_put_(p_val in raw, p_type in cn_int8, p_flush in boolean) return cn_int32
  is
    language java name 'com.github.aig.kafka.compression.Decompressor.put(byte[], int, boolean) return int';
  
  function decompressor_put(p_val in raw, p_type in out nocopy cn_int8, p_flush in boolean default false) return cn_int32
  is
    l_size cn_int32;
  begin
    l_size := decompressor_put_(p_val, p_type, p_flush);
    if p_type > 0 then
      p_type := 0;
    end if;
    return l_size;
  end;
  
  function decompressor_get return raw
  is
    language java name 'com.github.aig.kafka.compression.Decompressor.get() return byte[]';
    
  
  
  /**
   * Расчет контрольной суммы crc32.
   * @param Исходящий буфер.
   * @param p_pos Позиция.
   * @param p_type Тип.
   * @return Контрольная сумма crc32.
   */
  function buf_crc32(p_buf in out nocopy te_output_buf,
                     p_pos in pls_integer,
                     p_type in varchar2 default c_crc32) return raw
  is
    l_val raw(32767);
    l_idx pls_integer;
    l_subpos pls_integer;
    l_init boolean := true;
  begin
    buf_pre_flush(p_buf);
    buf_pos(p_pos, l_idx, l_subpos);
    if l_subpos > c_0x00000001 then
      l_val := utl_raw.substr(p_buf.buf(l_idx), l_subpos);
      crc32_update(l_val, p_init => l_init, p_type => p_type);
      l_idx := l_idx + c_0x00000001;
    end if;  
    for i in l_idx .. p_buf.idx loop
      crc32_update(p_buf.buf(i), p_init => l_init, p_type => p_type);
    end loop;
    return enc_int(crc32_get, p_len => c_32bit);
  end;
  
  /**
   * Запись данных в буфер.
   * @param p_buf Буфер.
   * @param p_val Данные.
   * @param p_len Размер данных.
   * @param p_pos Позиция записи.
   *
   * Оптимизация записи небольших частей данных осуществляется при помощи предварительного буфера на 12 записей
   * и использования utl_raw.concat. При формировании запросов требуется запись по позиции, что приводит к необходимости
   * хранения запроса в памяти до его записи в поток tcp в переменной типа p_buf.
   */
  procedure put_raw(p_buf in out nocopy te_output_buf, 
                    p_val in raw, 
                    p_len in pls_integer default null, 
                    p_pos in pls_integer default null)
  is
    l_len pls_integer := p_len;
    l_pos_e pls_integer;
    l_idx pls_integer;
    l_pos pls_integer;
    l_idx_e pls_integer;
    l_sep pls_integer;
  begin
    if not p_val is null then
      if l_len is null then
        l_len := utl_raw.length(p_val);
      end if;
      if p_pos is null then -- Запись в конец.
        if p_buf.pre_idx = 12 or p_buf.pre_len + l_len > c_size then -- Пребуфер заполнен или длина превысит максимальную.
          buf_pre_flush(p_buf);
        end if;
        p_buf.pre_idx := p_buf.pre_idx + 1;
        p_buf.pre_buf(p_buf.pre_idx) := p_val;
        p_buf.pre_len := p_buf.pre_len + l_len;
      else -- Запись по позиции.
        l_pos_e := p_pos - 1 + l_len;
        if l_pos_e > p_buf.len and p_buf.pre_len > c_0x00000000 then
          buf_pre_flush(p_buf);
        end if;
        buf_pos(p_pos, l_idx, l_pos); -- Индекс и позиция в буфере.
        if l_idx <= p_buf.idx and l_pos + l_len <= c_size_a then
          p_buf.buf(l_idx) := utl_raw.overlay(p_val, p_buf.buf(l_idx), pos => l_pos, len => l_len);
        else
          l_idx_e := trunc((l_pos_e - 1) / c_size) + 1;
          -- Расширение буфера до позиции завершения записи.
          while p_buf.idx < l_idx_e loop
            if p_buf.subpos > c_0x00000000 then
              p_buf.buf(p_buf.idx) := utl_raw.overlay(p_buf.buf(p_buf.idx), c_zero_buf);
              p_buf.subpos := c_0x00000000;
            end if;
            p_buf.idx := p_buf.idx + 1; p_buf.buf(p_buf.idx) := '';
            p_buf.buf(p_buf.idx) := case when p_buf.idx < l_idx_e then c_zero_buf else c_zero_byte_buf end;
          end loop;
          -- Запись.
          if l_pos + l_len <= c_size_a then -- Одним интервалом.
            p_buf.buf(l_idx) := utl_raw.overlay(p_val, p_buf.buf(l_idx), pos => l_pos, len => l_len);
          else -- Двумя интервалами.
            l_sep := c_size_a - l_pos; -- Разделитель.
            p_buf.buf(l_idx) := utl_raw.overlay(p_val, p_buf.buf(l_idx), pos => l_pos, len => l_sep);
            l_idx := l_idx + c_0x00000001;
            p_buf.buf(l_idx) := utl_raw.overlay(utl_raw.substr(p_val, l_sep + 1), p_buf.buf(l_idx), pos => 1, len => l_len - l_sep);
          end if;
        end if;
      end if;
    end if;
  end;
  
  procedure put_int(p_buf in out nocopy te_output_buf,
                    p_val in cn_int32,
                    p_len in pls_integer default c_32bit,
                    p_pos in pls_integer default null)
  is
  begin
    put_raw(p_buf, enc_int(p_val, p_len => p_len), p_len => p_len, p_pos => p_pos);
  end;
  
  procedure put_varint(p_buf in out nocopy te_output_buf,
                       p_val in cn_int32,
                       p_len out nocopy pls_integer,
                       p_pos in pls_integer default null)
  is
    l_raw raw(5);
  begin
    l_raw := enc_varint(p_val, p_len);
    put_raw(p_buf, l_raw, p_len => p_len, p_pos => p_pos);
  end;
  
  procedure put_int64(p_buf in out nocopy te_output_buf,
                      p_val in cn_int64,
                      p_pos in pls_integer default null)
  is
  begin
    put_raw(p_buf, enc_int64(p_val), p_len => c_64bit, p_pos => p_pos);
  end;
  
  procedure put_boolean(p_buf in out nocopy te_output_buf,
                        p_val in cn_boolean,
                        p_pos in pls_integer default null)
  is
    l_val cn_int8 := 0;
  begin
    if p_val then
      l_val := 1;
    end if;
    put_int(p_buf, l_val, p_len => c_8bit, p_pos => p_pos);
  end;
 
  function get_string_size(p_val in cn_string, p_pre_len in pls_integer default c_16bit) return cn_int16
  is
    l_len pls_integer;
    l_size cn_int32 := 0;
  begin
    if not p_val is null then
      l_len := lengthb(p_val); -- TODO: Сделать определение длины с учетом кодировки базы данных.
      l_size := l_size + l_len;
    end if;
    if p_pre_len = c_16bit then
      l_size := l_size + p_pre_len;
    elsif p_pre_len = c_varint then
      l_size := l_size + get_varint_size(l_len);
    end if;
    return l_size;
  end;
  
  procedure put_string(p_buf in out nocopy te_output_buf,
                       p_val in cn_string,
                       p_pre_len in pls_integer default c_16bit,
                       p_pos in pls_integer default null)
  is
    l_val raw(c_size);
    l_len pls_integer;
    l_pos pls_integer := p_pos;
  begin
    l_val := enc_string(p_val);  
    if not l_val is null then
      l_len := utl_raw.length(l_val);
    end if;
    l_len := coalesce(l_len, c_0xffffffff);
    if p_pre_len = c_16bit then
      put_int(p_buf, l_len, p_len => c_16bit, p_pos => l_pos);
      l_pos := l_pos + p_pre_len;
    end if;
    if l_len > c_0x00000000 then
      put_raw(p_buf, l_val, p_len => l_len, p_pos => l_pos);
    end if;
  end;
  
  procedure put_int_set(p_buf in out nocopy te_output_buf, p_int_set in cn_int32_set, p_len in pls_integer default c_32bit)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_int_set.count, p_len => c_32bit);
    l_i := p_int_set.first;
    loop
      exit when l_i is null;
      put_int(p_buf, p_int_set(l_i), p_len);
      l_i := p_int_set.next(l_i);
    end loop;
  end;
  
  procedure put_string_set(p_buf in out nocopy te_output_buf, p_string_set in cn_string_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_string_set.count, p_len => c_32bit);
    l_i := p_string_set.first;
    loop
      exit when l_i is null;
      put_string(p_buf, p_string_set(l_i));
      l_i := p_string_set.next(l_i);
    end loop;
  end;
  
  function get_data_size(p_val in blob, p_pre_len in pls_integer default c_32bit) return cn_int32
  is
    l_len pls_integer := 0;
    l_size cn_int32 := 0;
  begin
    if not p_val is null then
      l_len := dbms_lob.getlength(p_val);
      l_size := l_size + l_len;
    end if;
    if p_pre_len in (c_16bit, c_32bit) then
      l_size := l_size + p_pre_len;
    elsif p_pre_len = c_varint then
      l_size := l_size + get_varint_size(l_len);
    end if;
    return l_size;
  end;
  
  procedure put_data(p_buf in out nocopy te_output_buf,
                     p_val in blob,
                     p_pre_len in pls_integer default c_32bit,
                     p_pos in pls_integer default null)
  is
    l_len pls_integer := c_0xffffffff;
    l_varint_len pls_integer;
    l_pos pls_integer := p_pos;
    l_o pls_integer;
    l_val raw(c_size);
  begin
    if not p_val is null then
      l_len := dbms_lob.getlength(p_val);
    end if;
    l_len := coalesce(l_len, c_0xffffffff);
    if p_pre_len in (c_16bit, c_32bit) then
      put_int(p_buf, l_len, p_len => p_pre_len, p_pos => l_pos);
      l_pos := l_pos + p_pre_len;
    elsif p_pre_len = c_varint then
      put_varint(p_buf, l_len, l_varint_len, p_pos => p_pos);
      l_pos := l_pos + l_varint_len;
    end if;
    if l_len > c_0x00000000 then
      l_len := c_size; l_o := c_0x00000001;
      loop
        begin
          dbms_lob.read(p_val, l_len, l_o, l_val);
        exception
          when no_data_found then
            l_val := null; l_len := c_0x00000000;
        end;
        if l_len > c_0x00000000 then
          put_raw(p_buf, l_val, p_len => l_len, p_pos => l_pos);
          l_pos := l_pos + l_len; l_o := l_o + l_len;
        end if;
        exit when l_len < c_size;
      end loop;
    end if;
  end;
  
  function get_data_size(p_val in clob, p_pre_len in pls_integer default c_32bit) return cn_int32
  is
    l_len pls_integer := 0;
    l_size cn_int32 := 0;
  begin
    if not p_val is null then
      l_len := dbms_lob.getlength(p_val); -- TODO: Сделать определение длины с учетом кодировки базы данных.
      l_size := l_size + l_len;
    end if;
    if p_pre_len in (c_16bit, c_32bit) then
      l_size := l_size + p_pre_len;
    elsif p_pre_len = c_varint then
      l_size := l_size + get_varint_size(l_len);
    end if;
    return l_size;
  end;
  
  procedure put_data(p_buf in out nocopy te_output_buf,
                     p_val in out nocopy clob, 
                     p_pre_len in pls_integer default c_32bit,
                     p_pos in pls_integer default null)
  is
    l_len pls_integer := c_0xffffffff;
    l_varint_len pls_integer;
    l_pos pls_integer := p_pos;
    l_o pls_integer;
    l_val varchar2(8132);
  begin
    if not p_val is null then
      l_len := dbms_lob.getlength(p_val);
    end if;
    if p_pre_len in (c_16bit, c_32bit) then
      put_int(p_buf, l_len, p_len => p_pre_len, p_pos => p_pos);
      l_pos := l_pos + p_pre_len;
    elsif p_pre_len = c_varint then
      put_varint(p_buf, l_len, l_varint_len, p_pos => p_pos);
      l_pos := l_pos + l_varint_len;
    end if;
    if l_len > 0 then
      l_len := 8132; l_o := 1;
      loop
        begin
          dbms_lob.read(p_val, l_len, l_o, l_val);
        exception
          when no_data_found then
            l_val := null; l_len := 0;
        end;
        if l_len > 0 then
          put_string(p_buf, l_val, p_pre_len => null, p_pos => l_pos);
          l_pos := l_pos + l_len; l_o := l_o + l_len;
        end if;
        exit when l_len < 8132;
      end loop;
    end if;
  end;
  
  
  /**
   * Сжатие бинарных данных.
   * @param p_val Бинарные данные.
   * @param p_type Тип сжатия (инициализация при значении больше нуля).
   * @param p_flush Сброс буферов.
   * @return Количество блоков в выходном буфере.
   */
  function compressor_put_(p_val in raw, p_type in cn_int8, p_flush in boolean) return cn_int32
  is
    language java name 'com.github.aig.kafka.compression.Compressor.put(byte[], int, boolean) return int';
  
  /**
   * Сжатие бинарных данных.
   * @param p_val Бинарные данные.
   * @param p_type Тип сжатия (инициализация при значении больше нуля).
   * @param p_flush Сброс.
   * @return Количество блоков в выходном буфере.
   */
  function compressor_put(p_val in raw, p_type in out nocopy cn_int8, p_flush in boolean default false) return cn_int32
  is
    l_size cn_int32;
  begin
    l_size := compressor_put_(p_val, p_type, p_flush);
    if p_type > 0 then
      p_type := 0;
    end if;
    return l_size;
  end;
  
  /**
   * Получить сжатые бинарные данные из выходного буфера.
   * @return Сжатые бинарные данные.
   */
  function compressor_get return raw
  is
    language java name 'com.github.aig.kafka.compression.Compressor.get() return byte[]'; 
  
  /**
   * Компрессия исходящего буфера с указанной позиции.
   * @param p_buf Исходящий буфер.
   * @param p_pos Позиция.
   * @param p_type Тип компрессии.
   */
  procedure buf_compress(p_buf in out nocopy te_output_buf,
                         p_pos in cn_int64,
                         p_type in cn_int8)
  is
    l_idx cn_int32;
    l_subpos cn_int32;
    l_val raw(c_size);
    l_type cn_int8 := p_type;
    l_buf_count cn_int32;
    l_buf_idx cn_int32 := c_0x00000000;
    l_buf te_buf; -- Сжатые бинарные данные.
  begin
    buf_pre_flush(p_buf); -- Сброс пребуфера.
    if p_pos < p_buf.len then
      buf_pos(p_pos - 1, l_idx, l_subpos); -- Поцизия до сжатия.
      l_buf_count := p_buf.buf.count;
      if l_subpos < c_size then -- Сжатие части текущего элемента.
        l_val := utl_raw.substr(p_buf.buf(l_idx), l_subpos + c_0x00000001);
        for k in 1 .. compressor_put(l_val, l_type, (l_idx = l_buf_count)) loop
          l_buf_idx := l_buf_idx + c_0x00000001;
          l_buf(l_buf_idx) := compressor_get();
        end loop;
        p_buf.buf(l_idx) := utl_raw.substr(p_buf.buf(l_idx), c_0x00000001, l_subpos);
      end if;
      for i in l_idx + 1 .. l_buf_count loop
        for k in 1 .. compressor_put(p_buf.buf(i), l_type, (i = l_buf_count)) loop
          l_buf_idx := l_buf_idx + c_0x00000001;
          l_buf(l_buf_idx) := compressor_get();
        end loop;
        p_buf.buf.delete(i);
      end loop;
      -- Позиция до сжатия.
      p_buf.len := p_pos - 1;
      p_buf.idx := l_idx;
      p_buf.subpos := l_subpos;
      -- Запись сжатых данных.
      for i in 1 .. l_buf_idx loop
        put_raw(p_buf, l_buf(i));
      end loop;
    end if;
  end;
  
  /**
   * Декомпрессия входящего буфера с указанной позиции.
   * @param p_buf_in Входящий буфер.
   * @param p_buf_out Исходящий буфер.
   * @param p_len Размер.
   * @param p_type Тип компрессии.
   * @param p_pos Позиция.
   */
  procedure buf_decompress(p_buf_in in out nocopy te_input_buf,
                           p_buf_out out nocopy te_input_buf,
                           p_len in integer,
                           p_type in cn_int8,
                           p_pos in integer default null)
  is
    l_pos integer;
    l_idx pls_integer;
    l_subpos pls_integer;
    l_len integer;
    l_val raw(c_size);
    l_type cn_int8 := p_type;
    l_buf_idx pls_integer := 0;
  begin
    l_pos := coalesce(p_pos, p_buf_in.pos);
    if l_pos + p_len - c_0x00000001 <= p_buf_in.len then
      if p_pos is null then -- Чтение по текущему указателю.
        l_idx := p_buf_in.idx;
        l_subpos := p_buf_in.subpos;
      else
        buf_pos(l_pos, l_idx, l_subpos);
      end if;
      l_len := p_len;
      while l_len > 0 loop
        if l_subpos + l_len >= c_size_a then
          if l_subpos = c_0x00000001 then
            l_val := p_buf_in.buf(l_idx);
            l_len := l_len - c_size;
          else
            l_val := utl_raw.substr(p_buf_in.buf(l_idx), l_subpos);
            l_len := l_len - (c_size_a - l_subpos);
          end if;
          l_idx := l_idx + 1;
        else
          l_val := utl_raw.substr(p_buf_in.buf(l_idx), l_subpos, len => l_len);
          l_len := 0;
        end if;
        for i in 1 .. decompressor_put(l_val, l_type, (l_len = 0)) loop
          l_buf_idx := l_buf_idx + c_0x00000001;
          p_buf_out.buf(l_buf_idx) := decompressor_get();
        end loop;
      end loop;
      if p_pos is null then
        p_buf_in.pos := p_buf_in.pos + p_len;
        buf_pos(p_buf_in.pos, p_buf_in.idx, p_buf_in.subpos);
      end if;
      buf_init(p_buf_out);
    else -- Достигнут конец буфера.
      throw(1, 'The end of the input buffer has been reached.');
    end if;
  end;
  
  
  -- # Common API
  
  function read_legacy_record#attribute(p_buf in out nocopy te_input_buf) return cn_legacy_record#attribute
  is
    l_val cn_int8;
    l_attribute cn_legacy_record#attribute;
  begin
    l_val := read_int(p_buf, p_len => c_8bit, p_crc => true);
    l_attribute.compression_type := bitand(l_val, 7);
    l_attribute.timestamp_type := bitand(l_val, 8);
    return l_attribute;
  end;
  
  /*
  function read_legacy_record(p_buf in out nocopy te_input_buf, p_size in out nocopy pls_integer) return cn_legacy_record
  is
    l_legacy_record cn_legacy_record;
    l_len pls_integer := c_32bit;
    l_crc raw(c_32bit);
  begin
    
    return l_legacy_record;
  end;
  */
  
  procedure read_legacy_record_batch(p_buf in out nocopy te_input_buf, p_legacy_record_batch in out nocopy cn_legacy_record_batch, p_id in pls_integer default 0, p_pos_e in pls_integer default null)
  is
    l_pos_e integer;
    l_rem integer;
    l_id pls_integer;
    l_record cn_legacy_record;
    l_crc raw(c_32bit);
    l_value_size cn_int32;
    l_buf te_input_buf;
  begin
    if p_id = 0 then
      l_pos_e := p_buf.pos + read_int(p_buf, c_32bit);
    else
      l_pos_e := p_pos_e;
    end if;
    loop
      exit when p_buf.pos >= l_pos_e;
      l_rem := p_buf.len - p_buf.pos + c_0x00000001;
      if l_rem < 12 then -- Частичное сообщение.
        dbms_output.put_line('Частичное сообщение');
        read_ahead(p_buf, l_rem); exit;
      end if;
      l_record.offset := read_int64(p_buf);
      l_record.size_ := read_int(p_buf, c_32bit);
      l_rem := l_rem - 12;
      if l_record.size_ < 28 then
        throw(1, 'Record size (' || l_record.size_ || ') is less than the minimum record overhead (28)');
      end if;
      if l_rem < l_record.size_ then -- Частичное сообщение.
        dbms_output.put_line('Частичное сообщение');
        read_ahead(p_buf, l_rem); exit;
      end if;
      l_id := nvl(p_legacy_record_batch.record_set.last, 0) + 1;
      read_raw(p_buf, c_32bit, l_crc);
      -- init_crc(p_buf, p_crc_type => c_crc32b); -- Расчёт crc32b сообщения.
      l_record.magic := read_int(p_buf, c_8bit, p_crc => true);
      l_record.attribute := read_legacy_record#attribute(p_buf);
      if l_record.magic >= 1 then
        l_record.timestamp_ := read_int64(p_buf, p_crc => true);
      end if;
      l_record.key := read_data(p_buf, p_crc => true);
      
      if l_record.attribute.compression_type > c_0x00000000 then
        
        p_legacy_record_batch.record_set(l_id) := l_record;
        p_legacy_record_batch.record_tree(p_id)(l_id) := null;
      
        l_value_size := read_int(p_buf, c_32bit);
        
        -- Декомпрессия.
        buf_init(l_buf);
        buf_decompress(p_buf, l_buf, l_value_size, l_record.attribute.compression_type);
        
        read_legacy_record_batch(l_buf, p_legacy_record_batch, p_id => l_id, p_pos_e => l_buf.pos + l_buf.len);
      else
        l_record.value := read_data(p_buf, p_crc => true);
        p_legacy_record_batch.record_set(l_id) := l_record;
        p_legacy_record_batch.record_tree(p_id)(l_id) := null;
      end if;
      -- if not l_crc = get_crc(p_buf) then
      --  raise invalid_number;
      -- end if;
    end loop;
  end;
  
  procedure put_legacy_record#attribute(p_buf in out nocopy te_output_buf, p_attribute in cn_legacy_record#attribute)
  is
    l_val cn_int8 := c_0x00000000;
  begin
    l_val := bitor(l_val, bitand(p_attribute.timestamp_type, 8));
    l_val := bitor(l_val, bitand(p_attribute.compression_type, 7));
    put_int(p_buf, l_val, p_len => c_8bit);
  end;
  
  /*
  procedure put_legacy_record_tree(p_buf in out nocopy te_output_buf, 
                                   p_legacy_record_tree in cn_legacy_record_tree,
                                   p_id in pls_integer default 0, 
                                   p_pre_len in pls_integer default c_32bit);
  
  
  procedure put_legacy_record(p_buf in out nocopy te_output_buf, p_legacy_record_tree cn_legacy_record_tree, p_id in pls_integer)
  is
    l_legacy_record cn_legacy_record;
    l_size_pos pls_integer;
    l_crc_pos pls_integer;
    l_value_size_pos pls_integer;
    l_value_pos pls_integer;
    l_value_size pls_integer;
    l_crc raw(32767);
    l_size pls_integer;
  begin
    l_legacy_record := p_legacy_record_tree.record_set(p_id);
    put_int64(p_buf, l_legacy_record.offset);
    l_size_pos := buf_len(p_buf) + 1;
    put_int(p_buf, 0, p_len => c_32bit); -- Размер сообщения.
    l_crc_pos := l_size_pos + c_32bit;
    put_int(p_buf, 0, p_len => c_32bit); -- Crc сообщения.
    put_int(p_buf, l_legacy_record.magic, p_len => c_8bit);
    put_legacy_record_attribute(p_buf, l_legacy_record.attribute);
    if l_legacy_record.magic >= 1 then
      put_int64(p_buf, l_legacy_record.timestamp_);
    end if;
    put_data(p_buf, l_legacy_record.key);
    if l_legacy_record.attribute.compression_type > c_0x00000000 then -- Наличие сжатия.
      l_value_size_pos := buf_len(p_buf) + 1;
      put_int(p_buf, 0, p_len => c_32bit); -- Размер данных.
      l_value_pos := l_value_size_pos + c_32bit;
      -- Запись вложенных записей.      
      put_legacy_record_tree(p_buf, p_legacy_record_tree, p_id => p_id);
      -- Сжатие буфера.
      buf_compress(p_buf, l_value_pos, l_legacy_record.attribute.compression_type);
      l_value_size := buf_len(p_buf) - l_value_size_pos - 3;
      put_int(p_buf, l_value_size, p_len => c_32bit, p_pos => l_value_size_pos);
    else
      put_data(p_buf, l_legacy_record.value);
    end if;
    -- Получение crc сообщения.
    l_crc := buf_crc32(p_buf, l_crc_pos + c_32bit);
    put_raw(p_buf, l_crc, p_len => c_32bit, p_pos => l_crc_pos);
    l_size := buf_len(p_buf) - l_size_pos - 3;
    -- Запись размера сообщения.
    put_int(p_buf, l_size, p_len => c_32bit, p_pos => l_size_pos);
  end;
  */
  
  procedure put_legacy_record_batch(p_buf in out nocopy te_output_buf, 
                                    p_legacy_record_batch in cn_legacy_record_batch,
                                    p_id in pls_integer default 0, 
                                    p_pre_len in pls_integer default c_32bit)
  is
    l_batch_size_pos pls_integer;
    l_node_set cn_legacy_record_node_set;
    l_id pls_integer;
    l_legacy_record cn_legacy_record;
    l_size_pos pls_integer;
    l_crc_pos pls_integer;
    l_value_size_pos pls_integer;
    l_value_pos pls_integer;
    l_value_size pls_integer;
    l_crc raw(32767);
    l_size pls_integer;
    l_batch_size pls_integer;
  begin
    if p_pre_len = c_32bit then
      l_batch_size_pos := buf_len(p_buf) + 1;
      -- Под размер списка сообщений.
      put_int(p_buf, c_0x00000000, p_len => c_32bit);
    end if;
    if p_legacy_record_batch.record_tree.exists(p_id) then -- Дочерние записи.
      l_node_set := p_legacy_record_batch.record_tree(p_id);
      l_id := l_node_set.first;
      loop
        exit when l_id is null;
        l_legacy_record := p_legacy_record_batch.record_set(l_id);
        put_int64(p_buf, l_legacy_record.offset);
        l_size_pos := buf_len(p_buf) + 1;
        put_int(p_buf, 0, p_len => c_32bit); -- Размер сообщения.
        l_crc_pos := l_size_pos + c_32bit;
        put_int(p_buf, 0, p_len => c_32bit); -- Crc сообщения.
        put_int(p_buf, l_legacy_record.magic, p_len => c_8bit);
        put_legacy_record#attribute(p_buf, l_legacy_record.attribute);
        if l_legacy_record.magic >= 1 then
          put_int64(p_buf, l_legacy_record.timestamp_);
        end if;
        put_data(p_buf, l_legacy_record.key);
        if l_legacy_record.attribute.compression_type > c_0x00000000 then -- Наличие сжатия.
          l_value_size_pos := buf_len(p_buf) + 1;
          put_int(p_buf, 0, p_len => c_32bit); -- Размер данных.
          l_value_pos := l_value_size_pos + c_32bit;
          -- Запись вложенных записей.      
          put_legacy_record_batch(p_buf, p_legacy_record_batch, p_id => l_id, p_pre_len => null);
          buf_compress(p_buf, l_value_pos, l_legacy_record.attribute.compression_type);
          l_value_size := buf_len(p_buf) - l_value_size_pos - 3;
          put_int(p_buf, l_value_size, p_len => c_32bit, p_pos => l_value_size_pos);
        else
          put_data(p_buf, l_legacy_record.value);
        end if;
        -- Получение crc сообщения.
        l_crc := buf_crc32(p_buf, l_crc_pos + c_32bit);
        put_raw(p_buf, l_crc, p_len => c_32bit, p_pos => l_crc_pos);
        l_size := buf_len(p_buf) - l_size_pos - 3;
        -- Запись размера сообщения.
        put_int(p_buf, l_size, p_len => c_32bit, p_pos => l_size_pos);
        l_id := l_node_set.next(l_id);
      end loop;
    end if;
    -- Запись размера списка сообщений.
    if p_pre_len = c_32bit then
      l_batch_size := buf_len(p_buf) - l_batch_size_pos - 3;
      put_int(p_buf, l_batch_size, p_len => c_32bit, p_pos => l_batch_size_pos);
    end if;
  end;
  
  function read_record#header(p_buf in out nocopy te_input_buf) return cn_record#header
  is
    l_header cn_record#header;
  begin
    l_header.key := read_string(p_buf, p_pre_len => c_varint, p_crc => true);
    l_header.value := read_data(p_buf, p_pre_len => c_varint, p_crc => true);
    return l_header;
  end;
  
  function read_record_header_set(p_buf in out nocopy te_input_buf) return cn_record#header_set
  is
    l_size pls_integer;
    l_header_set cn_record#header_set;
  begin
    l_size := read_int(p_buf, c_32bit, p_crc => true);
    for i in 1 .. l_size loop
      l_header_set(i) := read_record#header(p_buf);
    end loop;
    return l_header_set;
  end;
  
  function read_record(p_buf in out nocopy te_input_buf, p_record_batch in cn_record_batch) return cn_record
  is
    l_record cn_record;
    l_len pls_integer;
    l_offset_delta pls_integer;
    l_varint_len pls_integer;
  begin
    l_len := read_varint(p_buf, l_varint_len, p_crc => true);
    l_record.attributes := read_int(p_buf, c_8bit, p_crc => true);
    l_record.timestamp_ := p_record_batch.base_timestamp + read_varint(p_buf, l_varint_len, p_crc => true);
    l_offset_delta := read_varint(p_buf, l_varint_len, p_crc => true);
    l_record.key := read_data(p_buf, p_pre_len => c_varint, p_crc => true);
    l_record.value := read_data(p_buf, p_pre_len => c_varint, p_crc => true);
    l_record.header_set := read_record_header_set(p_buf);
    return l_record;
  end;
  
  function read_record_set(p_buf in out nocopy te_input_buf, p_record_batch in cn_record_batch) return cn_record_set
  is
    l_size pls_integer;
    l_record_set cn_record_set;
  begin
    l_size := read_int(p_buf, c_32bit, p_crc => true);
    for i in 1 .. l_size loop
      l_record_set(i) := read_record(p_buf, p_record_batch);
    end loop;
    return l_record_set;
  end;
  
  function read_record_batch#attribute(p_buf in out nocopy te_input_buf) return cn_record_batch#attribute
  is
    l_val cn_int16;
    l_attribute cn_record_batch#attribute;
  begin
    l_val := read_int(p_buf, p_len => c_16bit, p_crc => true);
    l_attribute.compression_type := bitand(l_val, 7);
    l_attribute.timestamp_type := bitand(l_val, 8);
    l_attribute.is_transactional := bitand(l_val, 16) > 0;
    l_attribute.is_control := bitand(l_val, 32) > 0;
    return l_attribute;
  end;
  
  function read_record_batch(p_buf in out nocopy te_input_buf) return cn_record_batch
  is
    l_len pls_integer;
    l_record_batch cn_record_batch;
  begin
    l_record_batch.first_offset := read_int64(p_buf);
    l_len := read_int(p_buf, p_len => c_32bit);
    l_record_batch.partition_leader_epoch := read_int(p_buf, p_len => c_32bit);
    l_record_batch.magic:= read_int(p_buf, p_len => c_8bit);
    l_record_batch.crc := read_int(p_buf, p_len => c_32bit);
    
    l_record_batch.attribute := read_record_batch#attribute(p_buf);
    l_record_batch.last_offset_delta := read_int(p_buf, p_len => c_32bit, p_crc => true);
    l_record_batch.base_timestamp := read_int64(p_buf, p_crc => true);
    l_record_batch.max_timestamp := read_int64(p_buf, p_crc => true);
    l_record_batch.producer_id := read_int64(p_buf, p_crc => true);
    l_record_batch.producer_epoch := read_int(p_buf, p_len => c_16bit, p_crc => true);
    l_record_batch.base_sequence := read_int(p_buf, p_len => c_32bit, p_crc => true);
    l_record_batch.record_set := read_record_set(p_buf, l_record_batch);
    return l_record_batch;
  end;
  
  procedure put_record#header(p_buf in out nocopy te_output_buf, p_header in cn_record#header)
  is
  begin
    put_string(p_buf, p_header.key, p_pre_len => c_varint);
    put_data(p_buf, p_header.value, p_pre_len => c_varint);
  end;
  
  procedure put_record#header_set(p_buf in out nocopy te_output_buf, p_header_set in cn_record#header_set)
  is
    l_varint_len pls_integer;
    l_i pls_integer;
  begin
    put_varint(p_buf, p_header_set.count, l_varint_len);
    l_i := p_header_set.first;
    loop
      exit when l_i is null;
      put_record#header(p_buf, p_header_set(l_i));
      l_i := p_header_set.next(l_i);
    end loop;
  end;
  
  /**
   * Получение размера записи.
   * @param p_record Запись.
   * @param p_timestamp_delta 
   * @return Размер записи.
   */
  function get_record_size(p_record in cn_record,
                           p_timestamp_delta in cn_int32,
                           p_offset_delta cn_int32) return cn_int32
  is
    l_size cn_int32 := c_0x00000001;
    l_i pls_integer;
    l_header cn_record#header;
  begin
    l_size := l_size + get_varint_size(p_timestamp_delta);
    l_size := l_size + get_varint_size(p_offset_delta);
    l_size := l_size + get_data_size(p_record.key, p_pre_len => c_varint);
    l_size := l_size + get_data_size(p_record.value, p_pre_len => c_varint);
    l_size := l_size + get_varint_size(p_record.header_set.count);
    l_i := p_record.header_set.first;
    loop
      exit when l_i is null;
      l_header := p_record.header_set(l_i);
      l_size := l_size + get_string_size(l_header.key, p_pre_len => c_varint);
      l_size := l_size + get_data_size(l_header.value, p_pre_len => c_varint);
      l_i := p_record.header_set.next(l_i);
    end loop;
    return l_size;
  end;
  
  procedure put_record(p_buf in out nocopy te_output_buf, 
                       p_record in cn_record, 
                       p_base_timestamp in cn_int64,
                       p_offset_delta in cn_int32)
  is
    l_timestamp_delta cn_int32;
    l_size pls_integer;
    l_varint_len pls_integer;
  begin
    l_timestamp_delta := p_record.timestamp_ - p_base_timestamp;
    l_size := get_record_size(p_record, l_timestamp_delta, p_offset_delta);
    put_varint(p_buf, l_size, l_varint_len);
    put_int(p_buf, p_record.attributes, p_len => c_8bit);
    put_varint(p_buf, l_timestamp_delta, l_varint_len);
    put_varint(p_buf, p_offset_delta, l_varint_len);
    put_data(p_buf, p_record.key, p_pre_len => c_varint);
    put_data(p_buf, p_record.value, p_pre_len => c_varint);
    put_record#header_set(p_buf, p_record.header_set);
  end;
  
  procedure put_record_set(p_buf in out nocopy te_output_buf, 
                           p_record_batch in cn_record_batch,
                           p_base_timestamp in cn_int64)
  is
    l_i pls_integer;
    l_compress_pos integer;
  begin
    put_int(p_buf, p_record_batch.record_set.count, p_len => c_32bit);
    if p_record_batch.attribute.compression_type > c_0x00000001 then
      l_compress_pos := buf_len(p_buf) + 1;
    end if;
    l_i := p_record_batch.record_set.first;
    for i in 1 .. p_record_batch.record_set.count loop
      put_record(p_buf, p_record_batch.record_set(l_i), p_base_timestamp, i - p_record_batch.first_offset - 1);
      l_i := p_record_batch.record_set.next(l_i);
    end loop;
    if p_record_batch.attribute.compression_type > c_0x00000001 then
      buf_compress(p_buf, l_compress_pos, p_record_batch.attribute.compression_type);
    end if;
  end;
  
  procedure put_record_batch#attribute(p_buf in out nocopy te_output_buf, p_attribute in cn_record_batch#attribute)
  is
    l_val cn_int16 := c_0x00000000;
  begin
    if p_attribute.is_control then
      l_val := 32;
    end if;
    if p_attribute.is_transactional then
      l_val := bitor(l_val, 16);
    end if;
    l_val := bitor(l_val, bitand(p_attribute.timestamp_type, 8));
    l_val := bitor(l_val, bitand(p_attribute.compression_type, 7));
    put_int(p_buf, l_val, p_len => c_16bit);
  end;
  
  procedure put_record_batch(p_buf in out nocopy te_output_buf, p_record_batch in cn_record_batch)
  is
    l_size_pos pls_integer;
    l_crc_pos pls_integer;
    l_i pls_integer;
    l_base_timestamp integer := c_0xffffffff;
    l_max_timestamp integer := c_0xffffffff;
    l_crc raw(4);
    l_size pls_integer;
  begin
    -- Под общий размер списка записей.
    put_int(p_buf, c_0x00000000, p_len => c_32bit);
    put_int64(p_buf, 0); -- Начальное смещение.
    l_size_pos := buf_len(p_buf) + 1;
    put_int(p_buf, c_0x00000000, p_len => c_32bit); -- Под размер списка записей.
    put_int(p_buf, coalesce(p_record_batch.partition_leader_epoch, c_0xffffffff), p_len => c_32bit);
    put_int(p_buf, 2, p_len => c_8bit);
    put_int(p_buf, c_0x00000000, p_len => c_32bit); -- Под crc записи.
    l_crc_pos := buf_len(p_buf) + 1;
    put_record_batch#attribute(p_buf, p_record_batch.attribute);
    put_int(p_buf, (p_record_batch.record_set.count - c_0x00000001), p_len => c_32bit); -- Под смещение последней записи.
    l_i := p_record_batch.record_set.first;
    if not l_i is null then
      l_base_timestamp := p_record_batch.record_set(l_i).timestamp_;
      loop
        exit when l_i is null;
        l_max_timestamp := greatest(l_max_timestamp, p_record_batch.record_set(l_i).timestamp_);
        l_i := p_record_batch.record_set.next(l_i);
      end loop;
    end if;
    put_int64(p_buf, l_base_timestamp);
    put_int64(p_buf, l_max_timestamp);
    put_int64(p_buf, coalesce(p_record_batch.producer_id, -1));
    put_int(p_buf, coalesce(p_record_batch.producer_epoch, c_0xffffffff), p_len => c_16bit);
    put_int(p_buf, coalesce(p_record_batch.base_sequence, c_0xffffffff), p_len => c_32bit);
    put_record_set(p_buf, p_record_batch, l_base_timestamp);
    l_crc := buf_crc32(p_buf, l_crc_pos, p_type => c_crc32c);
    put_raw(p_buf, l_crc, p_len => c_32bit, p_pos => l_crc_pos - c_32bit); -- Запись crc сообщения.
    l_size := buf_len(p_buf) - l_size_pos - 3;
    put_int(p_buf, l_size + 12, p_len => c_32bit, p_pos => l_size_pos - 12); -- Запись общего размера списка записей.
    put_int(p_buf, l_size, p_len => c_32bit, p_pos => l_size_pos); -- Запись размера списка сообщений.
  end;
  
  procedure put_rq_header(p_buf in out nocopy te_output_buf,
                          p_api_key in cn_int16,
                          p_rq_header in cn_header)
  is
  begin
    put_int(p_buf, p_api_key, p_len => c_16bit);
    put_int(p_buf, api_version(), p_len => c_16bit);
    put_int(p_buf, p_rq_header.correlation_id);
    put_string(p_buf, p_rq_header.client_id);
  end;
  

  -- # Produce (0)
  
  function read_rs_produce#partition(p_buf in out nocopy te_input_buf) return rs_produce#partition
  is
    l_produce_partition rs_produce#partition;
  begin
    l_produce_partition.partition_id := read_int(p_buf, c_32bit);
    l_produce_partition.error_code := read_int(p_buf, c_16bit);
    l_produce_partition.base_offset := read_int64(p_buf);
    if api_version() >= 2 then
      l_produce_partition.log_append_time := read_int64(p_buf);
    end if;
    if api_version() >= 5 then
      l_produce_partition.log_start_offset := read_int64(p_buf);
    end if;
    return l_produce_partition;
  end;
  
  function read_rs_produce#partition_set(p_buf in out nocopy te_input_buf) return rs_produce#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_produce#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_produce#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_produce#topic(p_buf in out nocopy te_input_buf) return rs_produce#topic
  is
    l_topic rs_produce#topic;
  begin
    l_topic.topic_name := read_string(p_buf);
    l_topic.partition_set := read_rs_produce#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_produce#topic_set(p_buf in out nocopy te_input_buf) return rs_produce#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_produce#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_produce#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_produce(p_buf in out nocopy te_input_buf) return rs_produce
  is
    l_rs_produce rs_produce;
  begin
    buf_init(p_buf);
    l_rs_produce.topic_set := read_rs_produce#topic_set(p_buf);
    if api_version() >= 1 then
      l_rs_produce.throttle_time := read_int(p_buf, c_32bit);
    end if;
    return l_rs_produce;
  end;
  
  procedure put_rq_produce#partition(p_buf in out nocopy te_output_buf, p_partition in rq_produce#partition)
  is
  begin
    put_int(p_buf, p_partition.partition_id, p_len => c_32bit);
    if api_version() >= 3 then
      put_record_batch(p_buf, p_partition.record_batch);
    else
      put_legacy_record_batch(p_buf, p_partition.legacy_record_batch);
    end if;
  end;
  
  procedure put_rq_produce#partition_set(p_buf in out nocopy te_output_buf, p_partition_set in rq_produce#partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_set.count, p_len => c_32bit);
    l_i := p_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_produce#partition(p_buf, p_partition_set(l_i));
      l_i := p_partition_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_produce#topic(p_buf in out nocopy te_output_buf, p_topic in rq_produce#topic)
  is
  begin
    put_string(p_buf, p_topic.topic_name);
    put_rq_produce#partition_set(p_buf, p_topic.partition_set);
  end;
  
  procedure put_rq_produce#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_produce#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_produce#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_produce(p_buf in out nocopy te_output_buf, p_rq_produce in rq_produce)
  is
  begin
    if api_version() >= 3 then
      put_string(p_buf, p_rq_produce.transactional_id);
    end if;
    put_int(p_buf, p_rq_produce.required_acks, p_len => c_16bit);
    put_int(p_buf, p_rq_produce.timeout, p_len => c_32bit);
    put_rq_produce#topic_set(p_buf, p_rq_produce.topic_set);
  end;
  
  procedure put_rq_produce(p_buf in out nocopy te_output_buf,
                           p_rq_header in cn_header,
                           p_rq_produce in rq_produce)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_produce, p_rq_header);
    -- Запись запроса.
    put_rq_produce(p_buf, p_rq_produce);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;

  -- # Fetch (1)
  
  function read_rs_fetch#aborted_tx(p_buf in out nocopy te_input_buf) return rs_fetch#aborted_tx
  is
    l_aborted_tx rs_fetch#aborted_tx;
  begin
    l_aborted_tx.producer_id := read_int64(p_buf);
    l_aborted_tx.first_offset := read_int64(p_buf);
    return l_aborted_tx;
  end;
  
  function read_rs_fetch#aborted_tx_set(p_buf in out nocopy te_input_buf) return rs_fetch#aborted_tx_set
  is
    l_size pls_integer;
    l_aborted_tx_set rs_fetch#aborted_tx_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_aborted_tx_set(i) := read_rs_fetch#aborted_tx(p_buf);
    end loop;
    return l_aborted_tx_set;
  end;
  
  function read_rs_fetch#partition(p_buf in out nocopy te_input_buf) return rs_fetch#partition
  is
    l_partition rs_fetch#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.error_code := read_int(p_buf, c_16bit);
    l_partition.hwm_offset := read_int64(p_buf);
    if api_version() >= 4 then
      l_partition.last_stable_offset := read_int64(p_buf);
      if api_version() >= 5 then
        l_partition.log_start_offset := read_int64(p_buf);
      end if;
      l_partition.aborted_tx_set := read_rs_fetch#aborted_tx_set(p_buf);
      if api_version() >= 11 then
        l_partition.preferred_read_replica := read_int(p_buf, c_32bit);
      end if;
    end if;
    read_legacy_record_batch(p_buf, l_partition.legacy_record_batch);
    return l_partition;
  end;
  
  function read_rs_fetch#partition_set(p_buf in out nocopy te_input_buf) return rs_fetch#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_fetch#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_fetch#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_fetch#topic(p_buf in out nocopy te_input_buf) return rs_fetch#topic
  is
    l_topic rs_fetch#topic;
  begin
    l_topic.topic_name := read_string(p_buf);
    l_topic.partition_set := read_rs_fetch#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_fetch#topic_set(p_buf in out nocopy te_input_buf) return rs_fetch#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_fetch#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_fetch#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_fetch(p_buf in out nocopy te_input_buf) return rs_fetch
  is
    l_rs_fetch rs_fetch;
  begin
    buf_init(p_buf);
    if api_version() >= 1 then
      l_rs_fetch.throttle_time := read_int(p_buf, c_32bit);
    end if;
    if api_version() >= 7 then
      l_rs_fetch.error_code := read_int(p_buf, c_16bit);
      l_rs_fetch.session_id := read_int(p_buf, c_32bit);
    end if;
    l_rs_fetch.topic_set := read_rs_fetch#topic_set(p_buf);
    return l_rs_fetch;
  end;
  
  procedure put_rq_fetch#partition(p_buf in out nocopy te_output_buf, p_partition in rq_fetch#partition)
  is
  begin
    put_int(p_buf, p_partition.partition_id, p_len => c_32bit);
    if api_version() >= 9 then
      put_int(p_buf, p_partition.current_leader_epoch, p_len => c_32bit);
    end if;
    put_int64(p_buf, p_partition.fetch_offset);
    if api_version() >= 5 then
      put_int64(p_buf, p_partition.log_start_offset);
    end if;
    put_int(p_buf, p_partition.max_bytes, p_len => c_32bit);
  end;
  
  procedure put_rq_fetch#partition_set(p_buf in out nocopy te_output_buf, p_partition_set in rq_fetch#partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_set.count, p_len => c_32bit);
    l_i := p_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_fetch#partition(p_buf, p_partition_set(l_i));
      l_i := p_partition_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_fetch#topic(p_buf in out nocopy te_output_buf, p_topic in rq_fetch#topic)
  is
  begin
    put_string(p_buf, p_topic.topic_name);
    put_rq_fetch#partition_set(p_buf, p_topic.partition_set);
  end;
  
  procedure put_rq_fetch#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_fetch#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_fetch#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_fetch#forgotten_topic(p_buf in out nocopy te_output_buf, p_topic in rq_fetch#forgotten_topic)
  is
  begin
    put_string(p_buf, p_topic.topic_name);
    put_int_set(p_buf, p_topic.forgotten_partition_set, p_len => c_32bit);
  end;
  
  procedure put_rq_fetch#forgotten_topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_fetch#forgotten_topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_fetch#forgotten_topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_fetch(p_buf in out nocopy te_output_buf, p_rq_fetch in rq_fetch)
  is
  begin
    put_int(p_buf, p_rq_fetch.replica_id, p_len => c_32bit);
    put_int(p_buf, p_rq_fetch.max_wait_time, p_len => c_32bit);
    put_int(p_buf, p_rq_fetch.min_bytes, p_len => c_32bit);
    if api_version() >= 3 then
      put_int(p_buf, p_rq_fetch.max_bytes, p_len => c_32bit);
    end if;
    if api_version() >= 4 then
      put_int(p_buf, p_rq_fetch.isolation_level, p_len => c_8bit);
    end if;
    if api_version() >= 7 then
      put_int(p_buf, p_rq_fetch.session_id, p_len => c_32bit);
      put_int(p_buf, p_rq_fetch.session_epoch, p_len => c_32bit);
    end if;
    put_rq_fetch#topic_set(p_buf, p_rq_fetch.topic_set);
    if api_version() >= 7 then
      put_rq_fetch#forgotten_topic_set(p_buf, p_rq_fetch.forgotten_topic_set);
    end if;
    if api_version() >= 11 then
      put_string(p_buf, p_rq_fetch.rack_id);
    end if;
  end;
  
  procedure put_rq_fetch(p_buf in out nocopy te_output_buf,
                         p_rq_header in cn_header,
                         p_rq_fetch in rq_fetch)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    put_int(p_buf, c_0x00000000, p_len => c_32bit); -- Размер запроса.
    put_rq_header(p_buf, ak_rq_fetch, p_rq_header); -- Запись заголовка.
    put_rq_fetch(p_buf, p_rq_fetch); -- Запись запроса.
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_len => c_32bit, p_pos => c_0x00000001);
  end;
  
  -- # List offsets (2)
  
  function read_rs_list_offset#partition(p_buf in out nocopy te_input_buf) return rs_list_offset#partition
  is
    l_partition rs_list_offset#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.error_code := read_int(p_buf, c_16bit);
    if api_version() <= 0 then
      l_partition.offset_set := read_int64_set(p_buf);
    end if;
    if api_version() >= 1 then
      l_partition.timestamp_ := read_int64(p_buf);
      l_partition.offset := read_int64(p_buf);
    end if;
    if api_version() >= 4 then
      l_partition.leader_epoch := read_int(p_buf, c_32bit);
    end if;
    return l_partition;
  end;
  
  function read_rs_list_offset#partition_set(p_buf in out nocopy te_input_buf) return rs_list_offset#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_list_offset#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_list_offset#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_list_offset#topic(p_buf in out nocopy te_input_buf) return rs_list_offset#topic
  is
    l_topic rs_list_offset#topic;
  begin
    l_topic.topic_name := read_string(p_buf);
    l_topic.partition_set := read_rs_list_offset#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_list_offset#topic_set(p_buf in out nocopy te_input_buf) return rs_list_offset#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_list_offset#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_list_offset#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_list_offset(p_buf in out nocopy te_input_buf) return rs_list_offset
  is
    l_rs_list_offset rs_list_offset;
  begin
    buf_init(p_buf);
    if api_version() >= 2 then
      l_rs_list_offset.throttle_time := read_int(p_buf,c_32bit);
    end if;
    l_rs_list_offset.topic_set := read_rs_list_offset#topic_set(p_buf);
    return l_rs_list_offset;
  end;
  
  procedure put_rq_list_offset#partition(p_buf in out nocopy te_output_buf, p_partition in rq_list_offset#partition)
  is
  begin
    put_int(p_buf, p_partition.partition_id, p_len => c_32bit);
    if api_version() >= 4 then
      put_int(p_buf, p_partition.current_leader_epoch, p_len => c_32bit);
    end if;
    put_int64(p_buf, p_partition.timestamp_);
    if api_version() = 0 then
      put_int(p_buf, p_partition.max_offsets, p_len => c_32bit);      
    end if;
  end;
  
  procedure put_rq_list_offset#partition_set(p_buf in out nocopy te_output_buf, p_partition_set in rq_list_offset#partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_set.count, p_len => c_32bit);
    l_i := p_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_list_offset#partition(p_buf, p_partition_set(l_i));
      l_i := p_partition_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_list_offset#topic(p_buf in out nocopy te_output_buf, p_topic in rq_list_offset#topic)
  is
  begin
    put_string(p_buf, p_topic.topic_name);
    put_rq_list_offset#partition_set(p_buf, p_topic.partition_set);
  end;
  
  procedure put_rq_list_offset#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_list_offset#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_list_offset#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_list_offset(p_buf in out nocopy te_output_buf, p_rq_list_offset in rq_list_offset)
  is
  begin
    put_int(p_buf, p_rq_list_offset.replica_id, p_len => c_32bit);
    if api_version() >= 2 then
      put_int(p_buf, p_rq_list_offset.isolation_level, p_len => c_8bit);
    end if;
    put_rq_list_offset#topic_set(p_buf, p_rq_list_offset.topic_set);
  end;
  
  procedure put_rq_list_offset(p_buf in out nocopy te_output_buf,
                               p_rq_header in cn_header,
                               p_rq_list_offset in rq_list_offset)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_list_offset, p_rq_header);
    -- Запись запроса.
    put_rq_list_offset(p_buf, p_rq_list_offset);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  -- # Metadata (3)
  
  function read_rs_metadata#broker(p_buf in out nocopy te_input_buf) return rs_metadata#broker
  is
    l_broker rs_metadata#broker;
  begin
    l_broker.node_id := read_int(p_buf, c_32bit);
    l_broker.host := read_string(p_buf);
    l_broker.port := read_int(p_buf, c_32bit);
    if api_version() >= 1 then
      l_broker.rack := read_string(p_buf);
    end if;
    return l_broker;
  end;
  
  function read_rs_metadata#broker_set(p_buf in out nocopy te_input_buf) return rs_metadata#broker_set
  is
    l_size pls_integer;
    l_broker_set rs_metadata#broker_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_broker_set(i) := read_rs_metadata#broker(p_buf);
    end loop;
    return l_broker_set;
  end;
  
  function read_rs_metadata#partition(p_buf in out nocopy te_input_buf) return rs_metadata#partition
  is
    l_partition rs_metadata#partition;
  begin
    l_partition.partition_error_code := read_int(p_buf, c_16bit);
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.leader := read_int(p_buf, c_32bit);
    if api_version() >= 7 then
      l_partition.leader_epoch := read_int(p_buf, c_32bit);
    end if;
    l_partition.replicas := read_int_set(p_buf, c_32bit);
    l_partition.isr := read_int_set(p_buf, c_32bit);
    if api_version() >= 5 then
      l_partition.offline_replicas := read_int_set(p_buf, c_32bit);
    end if;
    return l_partition;
  end;
  
  function read_rs_metadata#partition_set(p_buf in out nocopy te_input_buf) return rs_metadata#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_metadata#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_metadata#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_metadata#topic(p_buf in out nocopy te_input_buf) return rs_metadata#topic
  is
    l_topic rs_metadata#topic;
  begin
    l_topic.topic_error_code := read_int(p_buf, c_16bit);
    l_topic.topic_name := read_string(p_buf);
    if api_version() >= 1 then
      l_topic.is_internal := read_int(p_buf, c_8bit);
    end if;
    l_topic.partition_set := read_rs_metadata#partition_set(p_buf);
    if api_version() >= 8 then
      l_topic.topic_auth_ops := read_int(p_buf, c_32bit);
    end if;
    return l_topic;
  end;
  
  function read_rs_metadata#topic_set(p_buf in out nocopy te_input_buf) return rs_metadata#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_metadata#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_metadata#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_metadata(p_buf in out nocopy te_input_buf) return rs_metadata
  is
    l_metadata rs_metadata;
  begin
    buf_init(p_buf);
    if api_version() >= 3 then
      l_metadata.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_metadata.broker_set := read_rs_metadata#broker_set(p_buf);
    if api_version() >= 2 then
      l_metadata.cluster_id := read_string(p_buf);
    end if;
    if api_version() >= 1 then
      l_metadata.controller_id := read_int(p_buf, c_32bit);
    end if;
    l_metadata.topic_set := read_rs_metadata#topic_set(p_buf);
    if api_version() >= 8 then
      l_metadata.cluster_auth_ops := read_int(p_buf, c_32bit);
    end if;
    return l_metadata;
  end;
  
  procedure put_rq_metadata(p_buf in out nocopy te_output_buf, p_rq_metadata in rq_metadata)
  is
  begin
    put_string_set(p_buf, p_rq_metadata.topic_set);
    if api_version() >= 4 then
      put_boolean(p_buf, p_rq_metadata.auto_topic_creation);
    end if;
    if api_version() >= 8 then
      put_boolean(p_buf, p_rq_metadata.get_cluster_auth_ops);
      put_boolean(p_buf, p_rq_metadata.get_topic_auth_ops);
    end if;
  end;
  
  procedure put_rq_metadata(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_metadata in rq_metadata)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_metadata, p_rq_header);
    -- Запись запроса.
    put_rq_metadata(p_buf, p_rq_metadata);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  -- # Leader and isr (4)
  
  function read_rs_leader_and_isr#partition(p_buf in out nocopy te_input_buf) return rs_leader_and_isr#partition
  is
    l_partition rs_leader_and_isr#partition;
  begin
    l_partition.topic_name := read_string(p_buf);
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.error_code := read_int(p_buf, c_16bit);
    return l_partition;
  end;
  
  function read_rs_leader_and_isr#partition_set(p_buf in out nocopy te_input_buf) return rs_leader_and_isr#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_leader_and_isr#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_leader_and_isr#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_leader_and_isr(p_buf in out nocopy te_input_buf) return rs_leader_and_isr
  is
    l_leader_and_isr rs_leader_and_isr;
  begin
    buf_init(p_buf);
    l_leader_and_isr.error_code := read_int(p_buf, c_16bit);
    l_leader_and_isr.partition_set := read_rs_leader_and_isr#partition_set(p_buf);
    return l_leader_and_isr;
  end;
  
  procedure put_rq_leader_and_isr#live_leader(p_buf in out nocopy te_output_buf, p_live_leader in rq_leader_and_isr#live_leader)
  is
  begin
    put_int(p_buf, p_live_leader.broker_id);
    put_string(p_buf, p_live_leader.host);
    put_int(p_buf, p_live_leader.port);
  end;
  
  procedure put_rq_leader_and_isr#live_leader_set(p_buf in out nocopy te_output_buf, p_live_leader_set in rq_leader_and_isr#live_leader_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_live_leader_set.count, p_len => c_32bit);
    l_i := p_live_leader_set.first;
    loop
      exit when l_i is null;
      put_rq_leader_and_isr#live_leader(p_buf, p_live_leader_set(l_i));
      l_i := p_live_leader_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_leader_and_isr#partition_state(p_buf in out nocopy te_output_buf, p_partition_state in rq_leader_and_isr#partition_state)
  is
  begin
    put_string(p_buf, p_partition_state.topic_name);
    put_int(p_buf, p_partition_state.partition_id);
    put_int(p_buf, p_partition_state.controller_epoch);
    put_int(p_buf, p_partition_state.leader_key);
    put_int(p_buf, p_partition_state.leader_epoch);
    put_int_set(p_buf, p_partition_state.isr_replica_set);
    put_int(p_buf, p_partition_state.zk_version);
    put_int_set(p_buf, p_partition_state.replica_set);
    if api_version() >= 1 then
      put_boolean(p_buf, p_partition_state.is_new);
    end if;
  end;
  
  procedure put_rq_leader_and_isr#partition_state_set(p_buf in out nocopy te_output_buf, p_partition_state_set in rq_leader_and_isr#partition_state_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_state_set.count, p_len => c_32bit);
    l_i := p_partition_state_set.first;
    loop
      exit when l_i is null;
      put_rq_leader_and_isr#partition_state(p_buf, p_partition_state_set(l_i));
      l_i := p_partition_state_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_leader_and_isr#topic_state(p_buf in out nocopy te_output_buf, p_topic_state in rq_leader_and_isr#topic_state)
  is
  begin
    put_string(p_buf, p_topic_state.topic_name);
    put_rq_leader_and_isr#partition_state_set(p_buf, p_topic_state.partition_state_set);
  end;
  
  procedure put_rq_leader_and_isr#topic_state_set(p_buf in out nocopy te_output_buf, p_topic_state_set in rq_leader_and_isr#topic_state_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_state_set.count, p_len => c_32bit);
    l_i := p_topic_state_set.first;
    loop
      exit when l_i is null;
      put_rq_leader_and_isr#topic_state(p_buf, p_topic_state_set(l_i));
      l_i := p_topic_state_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_leader_and_isr(p_buf in out nocopy te_output_buf, p_rq_leader_and_isr in rq_leader_and_isr)
  is
  begin
    put_int(p_buf, p_rq_leader_and_isr.controller_id);
    put_int(p_buf, p_rq_leader_and_isr.controller_epoch);
    if api_version() < 2 then
      put_rq_leader_and_isr#partition_state_set(p_buf, p_rq_leader_and_isr.partition_state_set);
    end if;
    if api_version() >= 2 then
      put_int64(p_buf, p_rq_leader_and_isr.broker_epoch);
      put_rq_leader_and_isr#topic_state_set(p_buf, p_rq_leader_and_isr.topic_state_set);
    end if;
    put_rq_leader_and_isr#live_leader_set(p_buf, p_rq_leader_and_isr.live_leader_set);
  end;
  
  procedure put_rq_leader_and_isr(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_leader_and_isr in rq_leader_and_isr)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_leader_and_isr, p_rq_header);
    -- Запись запроса.
    put_rq_leader_and_isr(p_buf, p_rq_leader_and_isr);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  
  -- # Stop replica (5)
  
  function read_rs_stop_replica#partition(p_buf in out nocopy te_input_buf) return rs_stop_replica#partition
  is
    l_partition rs_stop_replica#partition;
  begin
    l_partition.topic_name := read_string(p_buf);
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.error_code := read_int(p_buf, c_16bit);
    return l_partition;
  end;
  
  function read_rs_stop_replica#partition_set(p_buf in out nocopy te_input_buf) return rs_stop_replica#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_stop_replica#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_stop_replica#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_stop_replica(p_buf in out nocopy te_input_buf) return rs_stop_replica
  is
    l_stop_replica rs_stop_replica;
  begin
    buf_init(p_buf);
    l_stop_replica.error_code := read_int(p_buf, c_16bit);
    l_stop_replica.partition_set := read_rs_stop_replica#partition_set(p_buf);
    return l_stop_replica;
  end;
  
  procedure put_rq_stop_replica#partition(p_buf in out nocopy te_output_buf, p_partition in rq_stop_replica#partition)
  is
  begin
    put_string(p_buf, p_partition.topic_name);
    put_int(p_buf, p_partition.partition_id);
  end;
  
  procedure put_rq_stop_replica#partition_set(p_buf in out nocopy te_output_buf, p_partition_set in rq_stop_replica#partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_set.count, p_len => c_32bit);
    l_i := p_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_stop_replica#partition(p_buf, p_partition_set(l_i));
      l_i := p_partition_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_stop_replica#topic(p_buf in out nocopy te_output_buf, p_topic in rq_stop_replica#topic)
  is
  begin
    put_string(p_buf, p_topic.topic_name);
    put_int_set(p_buf, p_topic.partition_set);
  end;
  
  procedure put_rq_stop_replica#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_stop_replica#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_stop_replica#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_stop_replica(p_buf in out nocopy te_output_buf, p_rq_stop_replica in rq_stop_replica)
  is
  begin
    put_int(p_buf, p_rq_stop_replica.controller_id);
    put_int(p_buf, p_rq_stop_replica.controller_epoch);
    if api_version() >= 1 then
      put_int64(p_buf, p_rq_stop_replica.broker_epoch);
    end if;
    put_boolean(p_buf, p_rq_stop_replica.delete_partition_set);
    if api_version() < 1 then
      put_rq_stop_replica#partition_set(p_buf, p_rq_stop_replica.partition_set);
    end if;
    if api_version() >= 1 then
      put_rq_stop_replica#topic_set(p_buf, p_rq_stop_replica.topic_set);
    end if;
  end;
  
  procedure put_rq_stop_replica(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_stop_replica in rq_stop_replica)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_stop_replica, p_rq_header);
    -- Запись запроса.
    put_rq_stop_replica(p_buf, p_rq_stop_replica);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  
  -- # Update metadata (6)
  
  function read_rs_update_metadata(p_buf in out nocopy te_input_buf) return rs_update_metadata
  is
    l_update_metadata rs_update_metadata;
  begin
    buf_init(p_buf);
    l_update_metadata.error_code := read_int(p_buf, c_16bit);
    return l_update_metadata;
  end;
  
  procedure put_rq_update_metadata#partition_state(p_buf in out nocopy te_output_buf, p_partition_state in rq_update_metadata#partition_state)
  is
  begin
    if api_version() < 5 then
      put_string(p_buf, p_partition_state.topic_name);
    end if;
    put_int(p_buf, p_partition_state.partition_id);
    put_int(p_buf, p_partition_state.controller_epoch);
    put_int(p_buf, p_partition_state.leader);
    put_int(p_buf, p_partition_state.leader_epoch);
    put_int_set(p_buf, p_partition_state.isr);
    put_int(p_buf, p_partition_state.zk_version);
    put_int_set(p_buf, p_partition_state.replica_set);
    if api_version() >= 4 then
      put_int_set(p_buf, p_partition_state.offline_replica_set);
    end if;
  end;
  
  procedure put_rq_update_metadata#partition_state_set(p_buf in out nocopy te_output_buf, p_partition_state_set in rq_update_metadata#partition_state_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_state_set.count, p_len => c_32bit);
    l_i := p_partition_state_set.first;
    loop
      exit when l_i is null;
      put_rq_update_metadata#partition_state(p_buf, p_partition_state_set(l_i));
      l_i := p_partition_state_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_update_metadata#topic_state(p_buf in out nocopy te_output_buf, p_topic_state in rq_update_metadata#topic_state)
  is
  begin
    put_string(p_buf, p_topic_state.topic_name);
    put_rq_update_metadata#partition_state_set(p_buf, p_topic_state.partition_state_set);
  end;
  
  procedure put_rq_update_metadata#topic_state_set(p_buf in out nocopy te_output_buf, p_topic_state_set in rq_update_metadata#topic_state_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_state_set.count, p_len => c_32bit);
    l_i := p_topic_state_set.first;
    loop
      exit when l_i is null;
      put_rq_update_metadata#topic_state(p_buf, p_topic_state_set(l_i));
      l_i := p_topic_state_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_update_metadata#endpoint(p_buf in out nocopy te_output_buf, p_endpoint in rq_update_metadata#endpoint)
  is
  begin
    put_int(p_buf, p_endpoint.port);
    put_string(p_buf, p_endpoint.host);
    if api_version() >= 3 then
      put_string(p_buf, p_endpoint.listener);
    end if;
    if api_version() >= 1 then
      put_int(p_buf, p_endpoint.security_protocol, p_len => c_16bit);
    end if;
  end;
  
  procedure put_rq_update_metadata#endpoint_set(p_buf in out nocopy te_output_buf, p_endpoint_set in rq_update_metadata#endpoint_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_endpoint_set.count, p_len => c_32bit);
    l_i := p_endpoint_set.first;
    loop
      exit when l_i is null;
      put_rq_update_metadata#endpoint(p_buf, p_endpoint_set(l_i));
      l_i := p_endpoint_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_update_metadata#broker(p_buf in out nocopy te_output_buf, p_broker in rq_update_metadata#broker)
  is
  begin
    put_int(p_buf, p_broker.id);
    if api_version() = 0 then
      put_string(p_buf, p_broker.host);
      put_int(p_buf, p_broker.port);
      if api_version() >= 1 then
        put_rq_update_metadata#endpoint_set(p_buf, p_broker.endpoint_set);
      end if;
      if api_version() >= 2 then
        put_string(p_buf, p_broker.rack);
      end if;
    end if;
  end;
  
  procedure put_rq_update_metadata#broker_set(p_buf in out nocopy te_output_buf, p_broker_set in rq_update_metadata#broker_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_broker_set.count, p_len => c_32bit);
    l_i := p_broker_set.first;
    loop
      exit when l_i is null;
      put_rq_update_metadata#broker(p_buf, p_broker_set(l_i));
      l_i := p_broker_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_update_metadata(p_buf in out nocopy te_output_buf, p_rq_update_metadata in rq_update_metadata)
  is
  begin
    put_int(p_buf, p_rq_update_metadata.controller_id);
    put_int(p_buf, p_rq_update_metadata.controller_epoch);
    if api_version() >= 5 then
      put_int64(p_buf, p_rq_update_metadata.broker_epoch);
      put_rq_update_metadata#topic_state_set(p_buf, p_rq_update_metadata.topic_state_set);
    end if;
    if api_version() < 5 then
      put_rq_update_metadata#partition_state_set(p_buf, p_rq_update_metadata.partition_state_set);
    end if;
    put_rq_update_metadata#broker_set(p_buf, p_rq_update_metadata.broker_set);
  end;
  
  procedure put_rq_update_metadata(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_metadata in rq_metadata)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_stop_replica, p_rq_header);
    -- Запись запроса.
    put_rq_metadata(p_buf, p_rq_metadata);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  

  -- # Controlled shutdown (7)
  
  function read_rs_controlled_shutdown#remaining_partition(p_buf in out nocopy te_input_buf) return rs_controlled_shutdown#remaining_partition
  is
    l_remaining_partition rs_controlled_shutdown#remaining_partition;
  begin
    l_remaining_partition.topic_name := read_string(p_buf);
    l_remaining_partition.partition_id := read_int(p_buf, c_32bit);
    return l_remaining_partition;
  end;
  
  function read_rs_controlled_shutdown#remaining_partition_set(p_buf in out nocopy te_input_buf) return rs_controlled_shutdown#remaining_partition_set
  is
    l_size pls_integer;
    l_remaining_partition_set rs_controlled_shutdown#remaining_partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_remaining_partition_set(i) := read_rs_controlled_shutdown#remaining_partition(p_buf);
    end loop;
    return l_remaining_partition_set;
  end;
  
  function read_rs_controlled_shutdown(p_buf in out nocopy te_input_buf) return rs_controlled_shutdown
  is
    l_controlled_shudown rs_controlled_shutdown;
  begin
    buf_init(p_buf);
    l_controlled_shudown.error_code := read_int(p_buf, c_16bit);
    l_controlled_shudown.remaining_partition_set := read_rs_controlled_shutdown#remaining_partition_set(p_buf);
    return l_controlled_shudown;
  end;
  
  procedure put_rq_controlled_shutdown(p_buf in out nocopy te_output_buf, p_rq_controlled_shutdown in rq_controlled_shutdown)
  is
  begin
    put_int(p_buf, p_rq_controlled_shutdown.broker_id);
    put_int64(p_buf, p_rq_controlled_shutdown.broker_epoch);
  end;
  
  procedure put_rq_controlled_shutdown(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_controlled_shutdown in rq_controlled_shutdown)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_controlled_shutdown, p_rq_header);
    -- Запись запроса.
    put_rq_controlled_shutdown(p_buf, p_rq_controlled_shutdown);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  -- # Offset commit (8)
  
  function read_rs_offset_commit#partition(p_buf in out nocopy te_input_buf) return rs_offset_commit#partition
  is
    l_partition rs_offset_commit#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.error_code := read_int(p_buf, c_16bit);
    return l_partition;
  end;
  
  function read_rs_offset_commit#partition_set(p_buf in out nocopy te_input_buf) return rs_offset_commit#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_offset_commit#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_offset_commit#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_offset_commit#topic(p_buf in out nocopy te_input_buf) return rs_offset_commit#topic
  is
    l_topic rs_offset_commit#topic;
  begin
    l_topic.topic_name := read_string(p_buf);
    l_topic.partition_set := read_rs_offset_commit#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_offset_commit#topic_set(p_buf in out nocopy te_input_buf) return rs_offset_commit#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_offset_commit#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_offset_commit#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_offset_commit(p_buf in out nocopy te_input_buf) return rs_offset_commit
  is
    l_rs_offset_commit rs_offset_commit;
  begin
    buf_init(p_buf);
    if api_version() >= 3 then
      l_rs_offset_commit.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_offset_commit.topic_set := read_rs_offset_commit#topic_set(p_buf);
    return l_rs_offset_commit;
  end;
  
  procedure put_rq_offset_commit#partition(p_buf in out nocopy te_output_buf, p_partition in rq_offset_commit#partition)
  is
  begin
    put_int(p_buf, p_partition.partition_id);
    put_int64(p_buf, p_partition.offset);
    if api_version() = 1 then
      put_int64(p_buf, p_partition.timestamp_);
    end if;
    if api_version() >= 6 then
      put_int(p_buf, p_partition.leader_epoch);
    end if;
    put_string(p_buf, p_partition.metadata);
  end;
  
  procedure put_rq_offset_commit#partition_set(p_buf in out nocopy te_output_buf, p_partition_set in rq_offset_commit#partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_set.count, p_len => c_32bit);
    l_i := p_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_offset_commit#partition(p_buf, p_partition_set(l_i));
      l_i := p_partition_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_offset_commit#topic(p_buf in out nocopy te_output_buf, p_topic in rq_offset_commit#topic)
  is
  begin
    put_string(p_buf, p_topic.topic_name);
    put_rq_offset_commit#partition_set(p_buf, p_topic.partition_set);
  end;
  
  procedure put_rq_offset_commit#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_offset_commit#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_offset_commit#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_offset_commit(p_buf in out nocopy te_output_buf, p_rq_offset_commit in rq_offset_commit)
  is
  begin
    put_string(p_buf, p_rq_offset_commit.group_id);
    if api_version() >= 1 then
      put_int(p_buf, p_rq_offset_commit.generation_id);
      put_string(p_buf, p_rq_offset_commit.member_id);
    end if;
    if api_version() between 2 and 4 then
      put_int64(p_buf, p_rq_offset_commit.retention_time);
    end if;
    if api_version() >= 7 then
      put_string(p_buf, p_rq_offset_commit.group_instance_id);
    end if;
    put_rq_offset_commit#topic_set(p_buf, p_rq_offset_commit.topic_set);
  end;
  
  procedure put_rq_offset_commit(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_offset_commit in rq_offset_commit)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_offset_commit, p_rq_header);
    -- Запись запроса.
    put_rq_offset_commit(p_buf, p_rq_offset_commit);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  
  -- # Offset fetch (9)
  
  function read_rs_offset_fetch#partition(p_buf in out nocopy te_input_buf) return rs_offset_fetch#partition
  is
    l_partition rs_offset_fetch#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.offset := read_int64(p_buf);
    if api_version() >= 5 then
      l_partition.committed_leader_epoch := read_int(p_buf, c_32bit);
    end if;
    l_partition.metadata := read_string(p_buf);
    l_partition.error_code := read_int(p_buf, c_16bit);
    return l_partition;
  end;
  
  function read_rs_offset_fetch#partition_set(p_buf in out nocopy te_input_buf) return rs_offset_fetch#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_offset_fetch#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_offset_fetch#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_offset_fetch#topic(p_buf in out nocopy te_input_buf) return rs_offset_fetch#topic
  is
    l_topic rs_offset_fetch#topic;
  begin
    l_topic.topic_name := read_string(p_buf);
    l_topic.partition_set := read_rs_offset_fetch#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_offset_fetch#topic_set(p_buf in out nocopy te_input_buf) return rs_offset_fetch#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_offset_fetch#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_offset_fetch#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_offset_fetch(p_buf in out nocopy te_input_buf) return rs_offset_fetch
  is
    l_rs_offset_fetch rs_offset_fetch;
  begin
    buf_init(p_buf);
    if api_version() >= 3 then
      l_rs_offset_fetch.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_offset_fetch.topic_set := read_rs_offset_fetch#topic_set(p_buf);
    if api_version() >= 2 then
      l_rs_offset_fetch.error_code := read_int(p_buf, c_16bit);
    end if;
    return l_rs_offset_fetch;
  end;
  
  procedure put_rq_offset_fetch#topic(p_buf in out nocopy te_output_buf, p_topic in rq_offset_fetch#topic)
  is
  begin
    put_string(p_buf, p_topic.topic_name);
    put_int_set(p_buf, p_topic.partition_set, c_32bit);
  end;
  
  procedure put_rq_offset_fetch#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_offset_fetch#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_offset_fetch#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_offset_fetch(p_buf in out nocopy te_output_buf, p_rq_offset_fetch in rq_offset_fetch)
  is
  begin
    put_string(p_buf, p_rq_offset_fetch.group_id);
    put_rq_offset_fetch#topic_set(p_buf, p_rq_offset_fetch.topic_set);
  end;
  
  procedure put_rq_offset_fetch(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_offset_fetch in rq_offset_fetch)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_offset_fetch, p_rq_header);
    -- Запись запроса.
    put_rq_offset_fetch(p_buf, p_rq_offset_fetch);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;


  -- # Find coordinator (10)
  
  procedure put_rq_find_coordinator(p_buf in out nocopy te_output_buf, p_rq_find_coordinator in rq_find_coordinator)
  is
  begin
    put_string(p_buf, p_rq_find_coordinator.key);
    if api_version() >= 1 then
      put_int(p_buf, p_rq_find_coordinator.key_type, c_8bit);
    end if;
  end;
  
  procedure put_rq_find_coordinator(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_find_coordinator in rq_find_coordinator)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_find_coordinator, p_rq_header);
    -- Запись запроса.
    put_rq_find_coordinator(p_buf, p_rq_find_coordinator);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_find_coordinator(p_buf in out nocopy te_input_buf) return rs_find_coordinator
  is
    l_rs_find_coordinator rs_find_coordinator;
  begin
    buf_init(p_buf);
    if api_version() >= 1 then
      l_rs_find_coordinator.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_find_coordinator.error_code := read_int(p_buf, c_16bit);
    if api_version() >= 1 then
      l_rs_find_coordinator.error_message := read_string(p_buf);
    end if;
    l_rs_find_coordinator.node_id := read_int(p_buf, c_32bit);
    l_rs_find_coordinator.host := read_string(p_buf);
    l_rs_find_coordinator.port := read_int(p_buf, c_32bit);
    return l_rs_find_coordinator;
  end;
  
  -- # Join group (11)
  
  procedure put_rq_join_group#protocol(p_buf in out nocopy te_output_buf, p_protocol in rq_join_group#protocol)
  is
  begin
    put_string(p_buf, p_protocol.name);
    put_data(p_buf, p_protocol.metadata);
  end;
  
  procedure put_rq_join_group#protocol_set(p_buf in out nocopy te_output_buf, p_protocol_set in rq_join_group#protocol_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_protocol_set.count, p_len => c_32bit);
    l_i := p_protocol_set.first;
    loop
      exit when l_i is null;
      put_rq_join_group#protocol(p_buf, p_protocol_set(l_i));
      l_i := p_protocol_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_join_group(p_buf in out nocopy te_output_buf, p_rq_join_group in rq_join_group)
  is
  begin
    put_string(p_buf, p_rq_join_group.group_id);
    put_int(p_buf, p_rq_join_group.session_timeout, c_32bit);
    if api_version() >= 1 then
      put_int(p_buf, p_rq_join_group.rebalance_timeout, c_32bit);
    end if;
    put_string(p_buf, p_rq_join_group.member_id);
    if api_version() >= 5 then
      put_string(p_buf, p_rq_join_group.instance_id);
    end if;
    put_string(p_buf, p_rq_join_group.protocol_type);
    put_rq_join_group#protocol_set(p_buf, p_rq_join_group.protocol_set);
  end;
  
  procedure put_rq_join_group(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_join_group in rq_join_group)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_join_group, p_rq_header);
    -- Запись запроса.
    put_rq_join_group(p_buf, p_rq_join_group);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_join_group#member(p_buf in out nocopy te_input_buf) return rs_join_group#member
  is
    l_member rs_join_group#member;
  begin
    l_member.member_id := read_string(p_buf);
    if api_version() >= 5 then
      l_member.instance_id := read_string(p_buf);
    end if;
    l_member.metadata := read_data(p_buf);
    return l_member;
  end;
  
  function read_rs_join_group#member_set(p_buf in out nocopy te_input_buf) return rs_join_group#member_set
  is
    l_size pls_integer;
    l_member_set rs_join_group#member_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_member_set(i) := read_rs_join_group#member(p_buf);
    end loop;
    return l_member_set;
  end;
  
  function read_rs_join_group(p_buf in out nocopy te_input_buf) return rs_join_group
  is
    l_rs_join_group rs_join_group;
  begin
    buf_init(p_buf);
    if api_version() >= 2 then
      l_rs_join_group.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_join_group.error_code := read_int(p_buf, c_16bit);
    l_rs_join_group.generation_id := read_int(p_buf, c_32bit);
    l_rs_join_group.protocol_name := read_string(p_buf);
    l_rs_join_group.leader_id := read_string(p_buf);
    l_rs_join_group.member_id := read_string(p_buf);
    l_rs_join_group.member_set := read_rs_join_group#member_set(p_buf);
    return l_rs_join_group;
  end;
  
  -- # Heartbeat (12)
  
  procedure put_rq_heartbeat(p_buf in out nocopy te_output_buf, p_rq_heartbeat in rq_heartbeat)
  is
  begin
    put_string(p_buf, p_rq_heartbeat.group_id);
    put_int(p_buf, p_rq_heartbeat.generation_id, c_32bit);
    put_string(p_buf, p_rq_heartbeat.member_id);
    if api_version() >= 3 then
      put_string(p_buf, p_rq_heartbeat.instance_id);
    end if;
  end;
  
  procedure put_rq_heartbeat(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_heartbeat in rq_heartbeat)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_heartbeat, p_rq_header);
    -- Запись запроса.
    put_rq_heartbeat(p_buf, p_rq_heartbeat);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_heartbeat(p_buf in out nocopy te_input_buf) return rs_heartbeat
  is
    l_rs_heartbeat rs_heartbeat;
  begin
    buf_init(p_buf);
    if api_version() >= 1 then
      l_rs_heartbeat.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_heartbeat.error_code := read_int(p_buf, c_16bit);
    return l_rs_heartbeat;
  end;
  
  
  -- # Leave group (13)
  
  procedure put_rq_leave_group(p_buf in out nocopy te_output_buf, p_rq_leave_group in rq_leave_group)
  is
  begin
    put_string(p_buf, p_rq_leave_group.group_id);
    put_string(p_buf, p_rq_leave_group.member_id);
  end;
  
  procedure put_rq_leave_group(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_leave_group in rq_leave_group)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_leave_group, p_rq_header);
    -- Запись запроса.
    put_rq_leave_group(p_buf, p_rq_leave_group);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_leave_group(p_buf in out nocopy te_input_buf) return rs_leave_group
  is
    l_rs_leave_group rs_leave_group;
  begin
    buf_init(p_buf);
    if api_version() >= 1 then
      l_rs_leave_group.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_leave_group.error_code := read_int(p_buf, c_16bit);
    return l_rs_leave_group;
  end;
  
  
  -- # Sync group (14)
  
  procedure put_rq_sync_group#assignment(p_buf in out nocopy te_output_buf, p_assignment in rq_sync_group#assignment)
  is
  begin
    put_string(p_buf, p_assignment.member_id);
    put_data(p_buf, p_assignment.assignment);
  end;
  
  procedure put_rq_sync_group#assignment_set(p_buf in out nocopy te_output_buf, p_assignment_set in rq_sync_group#assignment_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_assignment_set.count, p_len => c_32bit);
    l_i := p_assignment_set.first;
    loop
      exit when l_i is null;
      put_rq_sync_group#assignment(p_buf, p_assignment_set(l_i));
      l_i := p_assignment_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_sync_group(p_buf in out nocopy te_output_buf, p_rq_sync_group in rq_sync_group)
  is
  begin
    put_string(p_buf, p_rq_sync_group.group_id);
    put_int(p_buf, p_rq_sync_group.generation_id, c_32bit);
    put_string(p_buf, p_rq_sync_group.member_id);
    if api_version() >= 3 then
      put_string(p_buf, p_rq_sync_group.instance_id);
    end if;
    put_rq_sync_group#assignment_set(p_buf, p_rq_sync_group.assignment_set);
  end;
  
  procedure put_rq_sync_group(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_sync_group in rq_sync_group)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_sync_group, p_rq_header);
    -- Запись запроса.
    put_rq_sync_group(p_buf, p_rq_sync_group);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_sync_group(p_buf in out nocopy te_input_buf) return rs_sync_group
  is
    l_rs_sync_group rs_sync_group;
  begin
    buf_init(p_buf);
    if api_version() >= 1 then
      l_rs_sync_group.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_sync_group.error_code := read_int(p_buf, c_16bit);
    l_rs_sync_group.assignment := read_data(p_buf);
    return l_rs_sync_group;
  end;
  
  
  -- # Describe groups (15)
  
  procedure put_rq_describe_groups(p_buf in out nocopy te_output_buf, p_rq_describe_groups in rq_describe_groups)
  is
  begin
    put_string_set(p_buf, p_rq_describe_groups.group_set);
    if api_version() >= 3 then
      put_boolean(p_buf, p_rq_describe_groups.include_authorized_operations);
    end if;  
  end;
  
  procedure put_rq_describe_groups(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_groups in rq_describe_groups)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_describe_groups, p_rq_header);
    -- Запись запроса.
    put_rq_describe_groups(p_buf, p_rq_describe_groups);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_describe_groups#member(p_buf in out nocopy te_input_buf) return rs_describe_groups#member
  is
    l_member rs_describe_groups#member;
  begin
    l_member.member_id := read_string(p_buf);
    l_member.client_id := read_string(p_buf);
    l_member.client_host := read_string(p_buf);
    l_member.member_metadata := read_data(p_buf);
    l_member.member_assignment := read_data(p_buf);
    return l_member;
  end;
  
  function read_rs_describe_groups#member_set(p_buf in out nocopy te_input_buf) return rs_describe_groups#member_set
  is
    l_size pls_integer;
    l_member_set rs_describe_groups#member_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_member_set(i) := read_rs_describe_groups#member(p_buf);
    end loop;
    return l_member_set;
  end;
  
  function read_rs_describe_groups#group(p_buf in out nocopy te_input_buf) return rs_describe_groups#group
  is
    l_group rs_describe_groups#group;
  begin
    l_group.error_code := read_int(p_buf, c_16bit);
    l_group.group_id := read_string(p_buf);
    l_group.group_state := read_string(p_buf);
    l_group.protocol_type := read_string(p_buf);
    l_group.protocol_data := read_string(p_buf);
    l_group.member_set := read_rs_describe_groups#member_set(p_buf);
    return l_group;
  end;
  
  function read_rs_describe_groups#group_set(p_buf in out nocopy te_input_buf) return rs_describe_groups#group_set
  is
    l_size pls_integer;
    l_group_set rs_describe_groups#group_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_group_set(i) := read_rs_describe_groups#group(p_buf);
    end loop;
    return l_group_set;
  end;
  
  function read_rs_describe_groups(p_buf in out nocopy te_input_buf) return rs_describe_groups
  is
    l_rs_describe_groups rs_describe_groups;
  begin
    buf_init(p_buf);
    if api_version() >= 1 then
      l_rs_describe_groups.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_describe_groups.group_set := read_rs_describe_groups#group_set(p_buf);
    return l_rs_describe_groups;
  end;
  
  
  -- # List groups (16)
  
  procedure put_rq_list_groups(p_buf in out nocopy te_output_buf, p_rq_header in cn_header)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_list_groups, p_rq_header);
    -- Запись запроса.
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_list_groups#group(p_buf in out nocopy te_input_buf) return rs_list_groups#group
  is
    l_group rs_list_groups#group;
  begin
    l_group.group_id := read_string(p_buf);
    l_group.protocol_type := read_string(p_buf);
    return l_group;
  end;
  
  function read_rs_list_groups#group_set(p_buf in out nocopy te_input_buf) return rs_list_groups#group_set
  is
    l_size pls_integer;
    l_group_set rs_list_groups#group_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_group_set(i) := read_rs_list_groups#group(p_buf);
    end loop;
    return l_group_set;
  end;
  
  function read_rs_list_groups(p_buf in out nocopy te_input_buf) return rs_list_groups
  is
    l_rs_list_groups rs_list_groups;
  begin
    buf_init(p_buf);
    if api_version() >= 1 then
      l_rs_list_groups.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_list_groups.error_code := read_int(p_buf, c_16bit);
    l_rs_list_groups.group_set := read_rs_list_groups#group_set(p_buf);
    return l_rs_list_groups;
  end;
  
  
  -- # Sasl handshake (17)
  
  procedure put_rq_sasl_handshake(p_buf in out nocopy te_output_buf, p_rq_sasl_handshake in rq_sasl_handshake)
  is
  begin
    put_string(p_buf, p_rq_sasl_handshake.mechanism);
  end;
  
  procedure put_rq_sasl_handshake(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_sasl_handshake in rq_sasl_handshake)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_sasl_handshake, p_rq_header);
    -- Запись запроса.
    put_rq_sasl_handshake(p_buf, p_rq_sasl_handshake);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_sasl_handshake(p_buf in out nocopy te_input_buf) return rs_sasl_handshake
  is
    l_rs_sasl_handshake rs_sasl_handshake;
  begin
    buf_init(p_buf);
    l_rs_sasl_handshake.error_code := read_int(p_buf, c_16bit);
    l_rs_sasl_handshake.mechanism_set := read_string_set(p_buf);
    return l_rs_sasl_handshake;
  end;
  
  
  -- # Api versions (18)
   
  procedure put_rq_api_versions(p_buf in out nocopy te_output_buf, p_rq_header in cn_header)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_api_versions, p_rq_header);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_api_versions#api_key(p_buf in out nocopy te_input_buf) return rs_api_versions#api_key
  is
    l_api_key rs_api_versions#api_key;
  begin
    l_api_key.id := read_int(p_buf, c_16bit);
    l_api_key.min_version := read_int(p_buf, c_16bit);
    l_api_key.max_version := read_int(p_buf, c_16bit);
    return l_api_key;
  end;
  
  function read_rs_api_versions#api_key_set(p_buf in out nocopy te_input_buf) return rs_api_versions#api_key_set
  is
    l_size pls_integer;
    l_api_key_set rs_api_versions#api_key_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_api_key_set(i) := read_rs_api_versions#api_key(p_buf);
    end loop;
    return l_api_key_set;
  end;
  
  function read_rs_api_versions(p_buf in out nocopy te_input_buf) return rs_api_versions
  is
    l_rs_api_versions rs_api_versions;
  begin
    buf_init(p_buf);
    l_rs_api_versions.error_code := read_int(p_buf, c_16bit);
    l_rs_api_versions.api_key_set := read_rs_api_versions#api_key_set(p_buf);
    if api_version() >= 1 then
      l_rs_api_versions.throttle_time := read_int(p_buf, c_32bit);
    end if;
    return l_rs_api_versions;
  end;
  
  
  -- # Create topics (19)
  
  procedure put_rq_create_topics#assignment(p_buf in out nocopy te_output_buf, p_assignment in rq_create_topics#assignment)
  is
  begin
    put_int(p_buf, p_assignment.partition_id, c_32bit);
    put_int_set(p_buf, p_assignment.broker_id_set, p_len => c_32bit);
  end;
  
  procedure put_rq_create_topics#assignment_set(p_buf in out nocopy te_output_buf, p_assignment_set in rq_create_topics#assignment_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_assignment_set.count, p_len => c_32bit);
    l_i := p_assignment_set.first;
    loop
      exit when l_i is null;
      put_rq_create_topics#assignment(p_buf, p_assignment_set(l_i));
      l_i := p_assignment_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_create_topics#config(p_buf in out nocopy te_output_buf, p_config in rq_create_topics#config)
  is
  begin
    put_string(p_buf, p_config.name);
    put_string(p_buf, p_config.value);
  end;
  
  procedure put_rq_create_topics#config_set(p_buf in out nocopy te_output_buf, p_config_set in rq_create_topics#config_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_config_set.count, p_len => c_32bit);
    l_i := p_config_set.first;
    loop
      exit when l_i is null;
      put_rq_create_topics#config(p_buf, p_config_set(l_i));
      l_i := p_config_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_create_topics#topic(p_buf in out nocopy te_output_buf, p_topic in rq_create_topics#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_int(p_buf, p_topic.partition_count, c_32bit);
    put_int(p_buf, p_topic.replication_factor, c_16bit);
    put_rq_create_topics#assignment_set(p_buf, p_topic.assignment_set);
    put_rq_create_topics#config_set(p_buf, p_topic.config_set);
  end;
  
  procedure put_rq_create_topics#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_create_topics#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_create_topics#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_create_topics(p_buf in out nocopy te_output_buf, p_rq_create_topics in rq_create_topics)
  is
  begin
    put_rq_create_topics#topic_set(p_buf, p_rq_create_topics.topic_set);
    put_int(p_buf, p_rq_create_topics.timeout, c_32bit);
    if api_version() >= 1 then
      put_boolean(p_buf, p_rq_create_topics.validate_only);
    end if;  
  end;
  
  procedure put_rq_create_topics(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_create_topics in rq_create_topics)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_create_topics, p_rq_header);
    -- Запись запроса.
    put_rq_create_topics(p_buf, p_rq_create_topics);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_create_topics#topic(p_buf in out nocopy te_input_buf) return rs_create_topics#topic
  is
    l_topic rs_create_topics#topic;
  begin
    l_topic.name := read_string(p_buf);
    l_topic.error_code := read_int(p_buf, c_16bit);
    if api_version() >= 1 then
      l_topic.error_message := read_string(p_buf);
    end if;
    return l_topic;
  end;
  
  function read_rs_create_topics#topic_set(p_buf in out nocopy te_input_buf) return rs_create_topics#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_create_topics#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_create_topics#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_create_topics(p_buf in out nocopy te_input_buf) return rs_create_topics
  is
    l_rs_create_topics rs_create_topics;
  begin
    buf_init(p_buf);
    if api_version() >= 2 then
      l_rs_create_topics.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_create_topics.topic_set := read_rs_create_topics#topic_set(p_buf);
    return l_rs_create_topics;
  end;
  
  
  -- # Delete topics (20)
  
  procedure put_rq_delete_topics(p_buf in out nocopy te_output_buf, p_rq_delete_topics in rq_delete_topics)
  is
  begin
    put_string_set(p_buf, p_rq_delete_topics.topic_name_set);
    put_int(p_buf, p_rq_delete_topics.timeout, c_32bit);
  end;
  
  procedure put_rq_delete_topics(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_delete_topics in rq_delete_topics)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_delete_topics, p_rq_header);
    -- Запись запроса.
    put_rq_delete_topics(p_buf, p_rq_delete_topics);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_delete_topics#response(p_buf in out nocopy te_input_buf) return rs_delete_topics#response
  is
    l_response rs_delete_topics#response;
  begin
    l_response.name := read_string(p_buf);
    l_response.error_code := read_string(p_buf);
    return l_response;
  end;
  
  function read_rs_delete_topics#response_set(p_buf in out nocopy te_input_buf) return rs_delete_topics#response_set
  is
    l_size pls_integer;
    l_response_set rs_delete_topics#response_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_response_set(i) := read_rs_delete_topics#response(p_buf);
    end loop;
    return l_response_set;
  end;
  
  function read_rs_delete_topics(p_buf in out nocopy te_input_buf) return rs_delete_topics
  is
    l_rs_delete_topics rs_delete_topics;
  begin
    buf_init(p_buf);
    if api_version() >= 1 then
      l_rs_delete_topics.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_delete_topics.response_set := read_rs_delete_topics#response_set(p_buf);
    return l_rs_delete_topics;
  end;
  
  
  -- # Delete records (21)
  
  procedure put_rq_delete_records#partition(p_buf in out nocopy te_output_buf, p_partition in rq_delete_records#partition)
  is
  begin
    put_int(p_buf, p_partition.partition_id, c_32bit);
    put_int64(p_buf, p_partition.offset);
  end;
  
  procedure put_rq_delete_records#partition_set(p_buf in out nocopy te_output_buf, p_partition_set in rq_delete_records#partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_set.count, p_len => c_32bit);
    l_i := p_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_delete_records#partition(p_buf, p_partition_set(l_i));
      l_i := p_partition_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_delete_records#topic(p_buf in out nocopy te_output_buf, p_topic in rq_delete_records#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_rq_delete_records#partition_set(p_buf, p_topic.partition_set);
  end;
  
  procedure put_rq_delete_records#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_delete_records#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_delete_records#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_delete_records(p_buf in out nocopy te_output_buf, p_rq_delete_records in rq_delete_records)
  is
  begin
    put_rq_delete_records#topic_set(p_buf, p_rq_delete_records.topic_set);
    put_int(p_buf, p_rq_delete_records.timeout, c_32bit);
  end;
  
  procedure put_rq_delete_records(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_delete_records in rq_delete_records)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_delete_records, p_rq_header);
    -- Запись запроса.
    put_rq_delete_records(p_buf, p_rq_delete_records);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_delete_records#partition(p_buf in out nocopy te_input_buf) return rs_delete_records#partition
  is
    l_partition rs_delete_records#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.low_watermark := read_int64(p_buf);
    l_partition.error_code := read_int(p_buf, c_16bit);
    return l_partition;
  end;
  
  function read_rs_delete_records#partition_set(p_buf in out nocopy te_input_buf) return rs_delete_records#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_delete_records#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_delete_records#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_delete_records#topic(p_buf in out nocopy te_input_buf) return rs_delete_records#topic
  is
    l_topic rs_delete_records#topic;
  begin
    l_topic.name := read_string(p_buf);
    l_topic.partition_set := read_rs_delete_records#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_delete_records#topic_set(p_buf in out nocopy te_input_buf) return rs_delete_records#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_delete_records#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_delete_records#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_delete_records(p_buf in out nocopy te_input_buf) return rs_delete_records
  is
    l_rs_delete_records rs_delete_records;
  begin
    buf_init(p_buf);
    l_rs_delete_records.throttle_time := read_int(p_buf, c_32bit);
    l_rs_delete_records.topic_set := read_rs_delete_records#topic_set(p_buf);
    return l_rs_delete_records;
  end;
  
  
  -- # Init producer id (22)
  
  procedure put_rq_init_producer_id(p_buf in out nocopy te_output_buf, p_rq_init_producer_id in rq_init_producer_id)
  is
  begin
    put_string(p_buf, p_rq_init_producer_id.transactional_id);
    put_int(p_buf, p_rq_init_producer_id.transaction_timeout, c_32bit);
  end;
  
  procedure put_rq_init_producer_id(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_init_producer_id in rq_init_producer_id)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_init_producer_id, p_rq_header);
    -- Запись запроса.
    put_rq_init_producer_id(p_buf, p_rq_init_producer_id);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_init_producer_id(p_buf in out nocopy te_input_buf) return rs_init_producer_id
  is
    l_rs_init_producer_id rs_init_producer_id;
  begin
    buf_init(p_buf);
    l_rs_init_producer_id.throttle_time := read_int(p_buf, c_32bit);
    l_rs_init_producer_id.error_code := read_int(p_buf, c_16bit);
    l_rs_init_producer_id.producer_id := read_int64(p_buf);
    l_rs_init_producer_id.producer_epoch := read_int(p_buf, c_16bit);
    return l_rs_init_producer_id;
  end;
  
  
  -- # Offset for leader epoch (23)
  
  procedure put_rq_offset_for_leader_epoch#partition(p_buf in out nocopy te_output_buf, p_partition in rq_offset_for_leader_epoch#partition)
  is
  begin
    put_int(p_buf, p_partition.partition_id, c_32bit);
    if api_version() >= 2 then
      put_int(p_buf, p_partition.current_leader_epoch, c_32bit);
    end if;
    put_int(p_buf, p_partition.current_leader_epoch, c_32bit);
  end;
  
  procedure put_rq_offset_for_leader_epoch#partition_set(p_buf in out nocopy te_output_buf, p_partition_set in rq_offset_for_leader_epoch#partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_set.count, p_len => c_32bit);
    l_i := p_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_offset_for_leader_epoch#partition(p_buf, p_partition_set(l_i));
      l_i := p_partition_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_offset_for_leader_epoch#topic(p_buf in out nocopy te_output_buf, p_topic in rq_offset_for_leader_epoch#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_rq_offset_for_leader_epoch#partition_set(p_buf, p_topic.partition_set);
  end;
  
  procedure put_rq_offset_for_leader_epoch#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_offset_for_leader_epoch#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_offset_for_leader_epoch#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_offset_for_leader_epoch(p_buf in out nocopy te_output_buf, p_rq_offset_for_leader_epoch in rq_offset_for_leader_epoch)
  is
  begin
    if api_version() >= 3 then
      put_int(p_buf, p_rq_offset_for_leader_epoch.replica_id, c_32bit);
    end if;
    put_rq_offset_for_leader_epoch#topic_set(p_buf, p_rq_offset_for_leader_epoch.topic_set);
  end;
  
  procedure put_rq_offset_for_leader_epoch(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_offset_for_leader_epoch in rq_offset_for_leader_epoch)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_offset_for_leader_epoch, p_rq_header);
    -- Запись запроса.
    put_rq_offset_for_leader_epoch(p_buf, p_rq_offset_for_leader_epoch);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_offset_for_leader_epoch#partition(p_buf in out nocopy te_input_buf) return rs_offset_for_leader_epoch#partition
  is
    l_partition rs_offset_for_leader_epoch#partition;
  begin
    l_partition.error_code := read_int(p_buf, c_16bit);
    l_partition.partition_id := read_int(p_buf, c_32bit);
    if api_version() >= 1 then
      l_partition.leader_epoch := read_int(p_buf, c_32bit);
    end if;
    l_partition.end_offset := read_int64(p_buf);
    return l_partition;
  end;
  
  function read_rs_offset_for_leader_epoch#partition_set(p_buf in out nocopy te_input_buf) return rs_offset_for_leader_epoch#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_offset_for_leader_epoch#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_offset_for_leader_epoch#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_offset_for_leader_epoch#topic(p_buf in out nocopy te_input_buf) return rs_offset_for_leader_epoch#topic
  is
    l_topic rs_offset_for_leader_epoch#topic;
  begin
    l_topic.name := read_string(p_buf);
    l_topic.partition_set := read_rs_offset_for_leader_epoch#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_offset_for_leader_epoch#topic_set(p_buf in out nocopy te_input_buf) return rs_offset_for_leader_epoch#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_offset_for_leader_epoch#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_offset_for_leader_epoch#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_offset_for_leader_epoch(p_buf in out nocopy te_input_buf) return rs_offset_for_leader_epoch
  is
    l_rs_offset_for_leader_epoch rs_offset_for_leader_epoch;
  begin
    buf_init(p_buf);
    if api_version() >= 2 then
      l_rs_offset_for_leader_epoch.throttle_time := read_int(p_buf, c_32bit);
    end if;
    l_rs_offset_for_leader_epoch.topic_set := read_rs_offset_for_leader_epoch#topic_set(p_buf);
    return l_rs_offset_for_leader_epoch;
  end;
  
  
  -- # Add partitions to txn (24)
  
  procedure put_rq_add_partitions_to_txn#topic(p_buf in out nocopy te_output_buf, p_topic in rq_add_partitions_to_txn#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_int_set(p_buf, p_topic.partition_set, c_32bit);
  end;
  
  procedure put_rq_add_partitions_to_txn#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_add_partitions_to_txn#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_add_partitions_to_txn#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_add_partitions_to_txn(p_buf in out nocopy te_output_buf, p_rq_add_partitions_to_txn in rq_add_partitions_to_txn)
  is
  begin
    put_string(p_buf, p_rq_add_partitions_to_txn.transactional_id);
    put_int64(p_buf, p_rq_add_partitions_to_txn.producer_id);
    put_int(p_buf, p_rq_add_partitions_to_txn.producer_epoch, c_16bit);
    put_rq_add_partitions_to_txn#topic_set(p_buf, p_rq_add_partitions_to_txn.topic_set);
  end;
  
  procedure put_rq_add_partitions_to_txn(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_add_partitions_to_txn in rq_add_partitions_to_txn)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_add_partitions_to_txn, p_rq_header);
    -- Запись запроса.
    put_rq_add_partitions_to_txn(p_buf, p_rq_add_partitions_to_txn);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_add_partitions_to_txn#partition_result(p_buf in out nocopy te_input_buf) return rs_add_partitions_to_txn#partition_result
  is
    l_partition_result rs_add_partitions_to_txn#partition_result;
  begin
    l_partition_result.partition_id := read_int(p_buf, c_32bit);
    l_partition_result.error_code := read_int(p_buf, c_16bit);
    return l_partition_result;
  end;
  
  function read_rs_add_partitions_to_txn#partition_result_set(p_buf in out nocopy te_input_buf) return rs_add_partitions_to_txn#partition_result_set
  is
    l_size pls_integer;
    l_partition_result_set rs_add_partitions_to_txn#partition_result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_result_set(i) := read_rs_add_partitions_to_txn#partition_result(p_buf);
    end loop;
    return l_partition_result_set;
  end;
  
  function read_rs_add_partitions_to_txn#result(p_buf in out nocopy te_input_buf) return rs_add_partitions_to_txn#result
  is
    l_result rs_add_partitions_to_txn#result;
  begin
    l_result.name := read_string(p_buf);
    l_result.partition_result_set := read_rs_add_partitions_to_txn#partition_result_set(p_buf);
    return l_result;
  end;
  
  function read_rs_add_partitions_to_txn#result_set(p_buf in out nocopy te_input_buf) return rs_add_partitions_to_txn#result_set
  is
    l_size pls_integer;
    l_result_set rs_add_partitions_to_txn#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_add_partitions_to_txn#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_add_partitions_to_txn(p_buf in out nocopy te_input_buf) return rs_add_partitions_to_txn
  is
    l_rs_add_partitions_to_txn rs_add_partitions_to_txn;
  begin
    buf_init(p_buf);
    l_rs_add_partitions_to_txn.throttle_time := read_int(p_buf, c_32bit);
    l_rs_add_partitions_to_txn.result_set := read_rs_add_partitions_to_txn#result_set(p_buf);
    return l_rs_add_partitions_to_txn;
  end;
  
  
  -- # Add offsets to txn (25)
  
  procedure put_rq_add_offsets_to_txn(p_buf in out nocopy te_output_buf, p_rq_add_offsets_to_txn in rq_add_offsets_to_txn)
  is
  begin
    put_string(p_buf, p_rq_add_offsets_to_txn.transactional_id);
    put_int64(p_buf, p_rq_add_offsets_to_txn.producer_id);
    put_int(p_buf, p_rq_add_offsets_to_txn.producer_epoch, c_16bit);
    put_string(p_buf, p_rq_add_offsets_to_txn.group_id);
  end;
  
  procedure put_rq_add_offsets_to_txn(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_add_offsets_to_txn in rq_add_offsets_to_txn)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_add_offsets_to_txn, p_rq_header);
    -- Запись запроса.
    put_rq_add_offsets_to_txn(p_buf, p_rq_add_offsets_to_txn);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_add_offsets_to_txn(p_buf in out nocopy te_input_buf) return rs_add_offsets_to_txn
  is
    l_rs_add_offsets_to_txn rs_add_offsets_to_txn;
  begin
    buf_init(p_buf);
    l_rs_add_offsets_to_txn.throttle_time := read_int(p_buf, c_32bit);
    l_rs_add_offsets_to_txn.error_code := read_int(p_buf, c_16bit);
    return l_rs_add_offsets_to_txn;
  end;
  
  
  -- # End txn (26)
  
  procedure put_rq_end_txn(p_buf in out nocopy te_output_buf, p_rq_end_txn in rq_end_txn)
  is
  begin
    put_string(p_buf, p_rq_end_txn.transactional_id);
    put_int64(p_buf, p_rq_end_txn.producer_id);
    put_int(p_buf, p_rq_end_txn.producer_epoch, c_16bit);
    put_boolean(p_buf, p_rq_end_txn.commited);
  end;
  
  procedure put_rq_end_txn(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_end_txn in rq_end_txn)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_end_txn, p_rq_header);
    -- Запись запроса.
    put_rq_end_txn(p_buf, p_rq_end_txn);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_end_txn(p_buf in out nocopy te_input_buf) return rs_end_txn
  is
    l_rs_end_txn rs_end_txn;
  begin
    buf_init(p_buf);
    l_rs_end_txn.throttle_time := read_int(p_buf, c_32bit);
    l_rs_end_txn.error_code := read_int(p_buf, c_16bit);
    return l_rs_end_txn;
  end;
  
  
  -- # Write txn markers (27)
  
  procedure put_rq_write_txn_markers#topic(p_buf in out nocopy te_output_buf, p_topic in rq_write_txn_markers#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_int_set(p_buf, p_topic.partition_set, c_32bit);
  end;
  
  procedure put_rq_write_txn_markers#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_write_txn_markers#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_write_txn_markers#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_write_txn_markers#marker(p_buf in out nocopy te_output_buf, p_marker in rq_write_txn_markers#marker)
  is
  begin
    put_int64(p_buf, p_marker.producer_id);
    put_int(p_buf, p_marker.producer_epoch, c_16bit);
    put_boolean(p_buf, p_marker.transaction_result);
    put_rq_write_txn_markers#topic_set(p_buf, p_marker.topic_set);
    put_int(p_buf, p_marker.coordinator_epoch, c_32bit);
  end;
  
  procedure put_rq_write_txn_markers#marker_set(p_buf in out nocopy te_output_buf, p_marker_set in rq_write_txn_markers#marker_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_marker_set.count, p_len => c_32bit);
    l_i := p_marker_set.first;
    loop
      exit when l_i is null;
      put_rq_write_txn_markers#marker(p_buf, p_marker_set(l_i));
      l_i := p_marker_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_write_txn_markers(p_buf in out nocopy te_output_buf, p_rq_write_txn_markers in rq_write_txn_markers)
  is
  begin
    put_rq_write_txn_markers#marker_set(p_buf, p_rq_write_txn_markers.marker_set);
  end;
  
  procedure put_rq_write_txn_markers(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_write_txn_markers in rq_write_txn_markers)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_write_txn_markers, p_rq_header);
    -- Запись запроса.
    put_rq_write_txn_markers(p_buf, p_rq_write_txn_markers);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_write_txn_markers#partition(p_buf in out nocopy te_input_buf) return rs_write_txn_markers#partition
  is
    l_partition rs_write_txn_markers#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.error_code := read_int(p_buf, c_16bit);
    return l_partition;
  end;
  
  function read_rs_write_txn_markers#partition_set(p_buf in out nocopy te_input_buf) return rs_write_txn_markers#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_write_txn_markers#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_write_txn_markers#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_write_txn_markers#topic(p_buf in out nocopy te_input_buf) return rs_write_txn_markers#topic
  is
    l_topic rs_write_txn_markers#topic;
  begin
    l_topic.name := read_string(p_buf);
    l_topic.partition_set := read_rs_write_txn_markers#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_write_txn_markers#topic_set(p_buf in out nocopy te_input_buf) return rs_write_txn_markers#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_write_txn_markers#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_write_txn_markers#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_write_txn_markers#marker(p_buf in out nocopy te_input_buf) return rs_write_txn_markers#marker
  is
    l_marker rs_write_txn_markers#marker;
  begin
    l_marker.producer_id := read_int64(p_buf);
    l_marker.topic_set := read_rs_write_txn_markers#topic_set(p_buf);
    return l_marker;
  end;
  
  function read_rs_write_txn_markers#marker_set(p_buf in out nocopy te_input_buf) return rs_write_txn_markers#marker_set
  is
    l_size pls_integer;
    l_marker_set rs_write_txn_markers#marker_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_marker_set(i) := read_rs_write_txn_markers#marker(p_buf);
    end loop;
    return l_marker_set;
  end;
  
  function read_rs_write_txn_markers(p_buf in out nocopy te_input_buf) return rs_write_txn_markers
  is
    l_rs_write_txn_markers rs_write_txn_markers;
  begin
    buf_init(p_buf);
    l_rs_write_txn_markers.marker_set := read_rs_write_txn_markers#marker_set(p_buf);
    return l_rs_write_txn_markers;
  end;
  
  
  -- # Txn offset commit (28)
  
  procedure put_rq_txn_offset_commit#partition(p_buf in out nocopy te_output_buf, p_partition in rq_txn_offset_commit#partition)
  is
  begin
    put_int(p_buf, p_partition.partition_id, c_32bit);
    put_int64(p_buf, p_partition.committed_offset);
    if api_version() >= 2 then
      put_int(p_buf, p_partition.committed_leader_epoch, c_32bit);
    end if;
    put_string(p_buf, p_partition.committed_metadata);
  end;
  
  procedure put_rq_txn_offset_commit#partition_set(p_buf in out nocopy te_output_buf, p_partition_set in rq_txn_offset_commit#partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_partition_set.count, p_len => c_32bit);
    l_i := p_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_txn_offset_commit#partition(p_buf, p_partition_set(l_i));
      l_i := p_partition_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_txn_offset_commit#topic(p_buf in out nocopy te_output_buf, p_topic in rq_txn_offset_commit#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_rq_txn_offset_commit#partition_set(p_buf, p_topic.partition_set);
  end;
  
  procedure put_rq_txn_offset_commit#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_txn_offset_commit#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_txn_offset_commit#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_txn_offset_commit(p_buf in out nocopy te_output_buf, p_rq_txn_offset_commit in rq_txn_offset_commit)
  is
  begin
    put_string(p_buf, p_rq_txn_offset_commit.transactional_id);
    put_string(p_buf, p_rq_txn_offset_commit.group_id);
    put_int64(p_buf, p_rq_txn_offset_commit.producer_id);
    put_int(p_buf, p_rq_txn_offset_commit.producer_epoch, c_16bit);
    put_rq_txn_offset_commit#topic_set(p_buf, p_rq_txn_offset_commit.topic_set);
  end;
  
  procedure put_rq_txn_offset_commit(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_txn_offset_commit in rq_txn_offset_commit)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_txn_offset_commit, p_rq_header);
    -- Запись запроса.
    put_rq_txn_offset_commit(p_buf, p_rq_txn_offset_commit);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_txn_offset_commit#partition(p_buf in out nocopy te_input_buf) return rs_txn_offset_commit#partition
  is
    l_partition rs_txn_offset_commit#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.error_code := read_int(p_buf, c_16bit);
    return l_partition;
  end;
  
  function read_rs_txn_offset_commit#partition_set(p_buf in out nocopy te_input_buf) return rs_txn_offset_commit#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_txn_offset_commit#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_txn_offset_commit#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_txn_offset_commit#topic(p_buf in out nocopy te_input_buf) return rs_txn_offset_commit#topic
  is
    l_topic rs_txn_offset_commit#topic;
  begin
    l_topic.name := read_string(p_buf);
    l_topic.partition_set := read_rs_txn_offset_commit#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_txn_offset_commit#topic_set(p_buf in out nocopy te_input_buf) return rs_txn_offset_commit#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_txn_offset_commit#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_txn_offset_commit#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_txn_offset_commit(p_buf in out nocopy te_input_buf) return rs_txn_offset_commit
  is
    l_rs_txn_offset_commit rs_txn_offset_commit;
  begin
    buf_init(p_buf);
    l_rs_txn_offset_commit.throttle_time := read_int(p_buf, c_32bit);
    l_rs_txn_offset_commit.topic_set := read_rs_txn_offset_commit#topic_set(p_buf);
    return l_rs_txn_offset_commit;
  end;
  
  
  -- # Describe acls (29)
  
  procedure put_rq_describe_acls(p_buf in out nocopy te_output_buf, p_rq_describe_acls in rq_describe_acls)
  is
  begin
    put_int(p_buf, p_rq_describe_acls.resource_type, c_8bit);
    put_string(p_buf, p_rq_describe_acls.resource_name_filter);
    if api_version() >= 1 then
      put_int(p_buf, p_rq_describe_acls.resource_pattern_type, c_8bit);    
    end if;
    put_string(p_buf, p_rq_describe_acls.principal_filter);    
    put_string(p_buf, p_rq_describe_acls.host_filter); 
    put_int(p_buf, p_rq_describe_acls.operation, c_8bit);
    put_int(p_buf, p_rq_describe_acls.permission_type, c_8bit);
  end;
  
  procedure put_rq_describe_acls(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_acls in rq_describe_acls)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_describe_acls, p_rq_header);
    -- Запись запроса.
    put_rq_describe_acls(p_buf, p_rq_describe_acls);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_describe_acls#acl(p_buf in out nocopy te_input_buf) return rs_describe_acls#acl
  is
    l_acl rs_describe_acls#acl;
  begin
    l_acl.principal := read_string(p_buf);
    l_acl.host := read_string(p_buf);
    l_acl.operation := read_int(p_buf, c_8bit);
    l_acl.permission_type := read_int(p_buf, c_8bit);
    return l_acl;
  end;
  
  function read_rs_describe_acls#acl_set(p_buf in out nocopy te_input_buf) return rs_describe_acls#acl_set
  is
    l_size pls_integer;
    l_acl_set rs_describe_acls#acl_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_acl_set(i) := read_rs_describe_acls#acl(p_buf);
    end loop;
    return l_acl_set;
  end;
  
  function read_rs_describe_acls#resource(p_buf in out nocopy te_input_buf) return rs_describe_acls#resource
  is
    l_resource rs_describe_acls#resource;
  begin
    l_resource.type := read_int(p_buf, c_8bit);
    l_resource.name := read_string(p_buf);
    if api_version() >= 1 then
      l_resource.pattern_type := read_int(p_buf, c_8bit);
    end if;
    l_resource.acl_set := read_rs_describe_acls#acl_set(p_buf);
    return l_resource;
  end;
  
  function read_rs_describe_acls#resource_set(p_buf in out nocopy te_input_buf) return rs_describe_acls#resource_set
  is
    l_size pls_integer;
    l_resource_set rs_describe_acls#resource_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_resource_set(i) := read_rs_describe_acls#resource(p_buf);
    end loop;
    return l_resource_set;
  end;
  
  function read_rs_describe_acls(p_buf in out nocopy te_input_buf) return rs_describe_acls
  is
    l_rs_describe_acls rs_describe_acls;
  begin
    buf_init(p_buf);
    l_rs_describe_acls.throttle_time := read_int(p_buf, c_32bit);
    l_rs_describe_acls.error_code := read_int(p_buf, c_16bit);
    l_rs_describe_acls.error_message := read_string(p_buf);
    l_rs_describe_acls.resource_set := read_rs_describe_acls#resource_set(p_buf);
    return l_rs_describe_acls;
  end;
  
  
  -- # Create acls (30)
  
  procedure put_rq_create_acls#creation(p_buf in out nocopy te_output_buf, p_creation in rq_create_acls#creation)
  is
  begin
    put_int(p_buf, p_creation.resource_type, c_8bit);
    put_string(p_buf, p_creation.resource_name);
    if api_version() >= 1 then
      put_int(p_buf, p_creation.resource_pattern_type, c_8bit);      
    end if;
    put_string(p_buf, p_creation.principal);
    put_string(p_buf, p_creation.host);
    put_int(p_buf, p_creation.operation, c_8bit);
    put_int(p_buf, p_creation.permission_type, c_8bit);
  end;
  
  procedure put_rq_create_acls#creation_set(p_buf in out nocopy te_output_buf, p_creation_set in rq_create_acls#creation_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_creation_set.count, p_len => c_32bit);
    l_i := p_creation_set.first;
    loop
      exit when l_i is null;
      put_rq_create_acls#creation(p_buf, p_creation_set(l_i));
      l_i := p_creation_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_create_acls(p_buf in out nocopy te_output_buf, p_rq_create_acls in rq_create_acls)
  is
  begin
    put_rq_create_acls#creation_set(p_buf, p_rq_create_acls.creation_set);
  end;

  procedure put_rq_create_acls(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_create_acls in rq_create_acls)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_create_acls, p_rq_header);
    -- Запись запроса.
    put_rq_create_acls(p_buf, p_rq_create_acls);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_create_acls#result(p_buf in out nocopy te_input_buf) return rs_create_acls#result
  is
    l_result rs_create_acls#result;
  begin
    l_result.error_code := read_int(p_buf, c_16bit);
    l_result.error_message := read_string(p_buf);
    return l_result;
  end;
  
  function read_rs_create_acls#result_set(p_buf in out nocopy te_input_buf) return rs_create_acls#result_set
  is
    l_size pls_integer;
    l_result_set rs_create_acls#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_create_acls#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_create_acls(p_buf in out nocopy te_input_buf) return rs_create_acls
  is
    l_rs_create_acls rs_create_acls;
  begin
    buf_init(p_buf);
    l_rs_create_acls.throttle_time := read_int(p_buf, c_32bit);
    l_rs_create_acls.result_set := read_rs_create_acls#result_set(p_buf);
    return l_rs_create_acls;
  end;
  
  
  -- # Delete acls (31)
  
  procedure put_rq_delete_acls#filter(p_buf in out nocopy te_output_buf, p_filter in rq_delete_acls#filter)
  is
  begin
    put_int(p_buf, p_filter.resource_type_filter, c_8bit);
    put_string(p_buf, p_filter.resource_name_filter);
    if api_version() >= 1 then
      put_int(p_buf, p_filter.pattern_type_filter, c_8bit);
    end if;
    put_string(p_buf, p_filter.principal_filter);
    put_string(p_buf, p_filter.host_filter);
    put_int(p_buf, p_filter.operation, c_8bit);
    put_int(p_buf, p_filter.permission_type, c_8bit);
  end;
  
  procedure put_rq_delete_acls#filter_set(p_buf in out nocopy te_output_buf, p_filter_set in rq_delete_acls#filter_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_filter_set.count, p_len => c_32bit);
    l_i := p_filter_set.first;
    loop
      exit when l_i is null;
      put_rq_delete_acls#filter(p_buf, p_filter_set(l_i));
      l_i := p_filter_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_delete_acls(p_buf in out nocopy te_output_buf, p_rq_delete_acls in rq_delete_acls)
  is
  begin
    put_rq_delete_acls#filter_set(p_buf, p_rq_delete_acls.filter_set);
  end;
  
  procedure put_rq_delete_acls(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_delete_acls in rq_delete_acls)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_delete_acls, p_rq_header);
    -- Запись запроса.
    put_rq_delete_acls(p_buf, p_rq_delete_acls);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_delete_acls#acl(p_buf in out nocopy te_input_buf) return rs_delete_acls#acl
  is
    l_acl rs_delete_acls#acl;
  begin
    l_acl.error_code := read_int(p_buf, c_16bit);
    l_acl.error_message := read_string(p_buf);
    l_acl.resource_type := read_int(p_buf, c_8bit);
    l_acl.resource_name := read_string(p_buf);
    if api_version() >= 1 then
      l_acl.pattern_type := read_int(p_buf, c_8bit);
    end if;
    l_acl.principal := read_string(p_buf);
    l_acl.host := read_string(p_buf);
    l_acl.operation := read_int(p_buf, c_8bit);
    l_acl.permission_type := read_int(p_buf, c_8bit);
    return l_acl;
  end;
  
  function read_rs_delete_acls#acl_set(p_buf in out nocopy te_input_buf) return rs_delete_acls#acl_set
  is
    l_size pls_integer;
    l_acl_set rs_delete_acls#acl_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_acl_set(i) := read_rs_delete_acls#acl(p_buf);
    end loop;
    return l_acl_set;
  end;
  
  function read_rs_delete_acls#result(p_buf in out nocopy te_input_buf) return rs_delete_acls#result
  is
    l_result rs_delete_acls#result;
  begin
    l_result.error_code := read_int(p_buf, c_16bit);
    l_result.error_message := read_string(p_buf);
    l_result.matching_acl_set := read_rs_delete_acls#acl_set(p_buf);
    return l_result;
  end;
  
  function read_rs_delete_acls#result_set(p_buf in out nocopy te_input_buf) return rs_delete_acls#result_set
  is
    l_size pls_integer;
    l_result_set rs_delete_acls#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_delete_acls#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_delete_acls(p_buf in out nocopy te_input_buf) return rs_delete_acls
  is
    l_rs_delete_acls rs_delete_acls;
  begin
    buf_init(p_buf);
    l_rs_delete_acls.throttle_time := read_int(p_buf, c_32bit);
    l_rs_delete_acls.filter_result_set := read_rs_delete_acls#result_set(p_buf);
    return l_rs_delete_acls;
  end;
  
  
  -- # Describe configs (32)
  
  procedure put_rq_describe_configs#resource(p_buf in out nocopy te_output_buf, p_resource in rq_describe_configs#resource)
  is
  begin
    put_int(p_buf, p_resource.resource_type, c_8bit);
    put_string(p_buf, p_resource.resource_name);
    put_string_set(p_buf, p_resource.configuration_key_set);
  end;
  
  procedure put_rq_describe_configs#resource_set(p_buf in out nocopy te_output_buf, p_resource_set in rq_describe_configs#resource_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_resource_set.count, p_len => c_32bit);
    l_i := p_resource_set.first;
    loop
      exit when l_i is null;
      put_rq_describe_configs#resource(p_buf, p_resource_set(l_i));
      l_i := p_resource_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_describe_configs(p_buf in out nocopy te_output_buf, p_rq_describe_configs in rq_describe_configs)
  is
  begin
    put_rq_describe_configs#resource_set(p_buf, p_rq_describe_configs.resource_set);
    if api_version() >= 1 then
      put_boolean(p_buf, p_rq_describe_configs.include_synonyms);
    end if;
  end;
  
  procedure put_rq_describe_configs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_configs in rq_describe_configs)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_describe_configs, p_rq_header);
    -- Запись запроса.
    put_rq_describe_configs(p_buf, p_rq_describe_configs);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_describe_configs#synonym(p_buf in out nocopy te_input_buf) return rs_describe_configs#synonym
  is
    l_synonym rs_describe_configs#synonym;
  begin
    l_synonym.name := read_string(p_buf);
    l_synonym.value := read_string(p_buf);
    l_synonym.source := read_int(p_buf, c_8bit);
    return l_synonym;
  end;
  
  function read_rs_describe_configs#synonym_set(p_buf in out nocopy te_input_buf) return rs_describe_configs#synonym_set
  is
    l_size pls_integer;
    l_synonym_set rs_describe_configs#synonym_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_synonym_set(i) := read_rs_describe_configs#synonym(p_buf);
    end loop;
    return l_synonym_set;
  end;
  
  function read_rs_describe_configs#config(p_buf in out nocopy te_input_buf) return rs_describe_configs#config
  is
    l_config rs_describe_configs#config;
  begin
    l_config.name := read_string(p_buf);
    l_config.value := read_string(p_buf);
    l_config.read_only := read_boolean(p_buf);
    if api_version() >= 1 then
      l_config.config_source := read_int(p_buf, c_8bit);
    else
      l_config.is_default := read_boolean(p_buf);
    end if;
    l_config.is_sensitive := read_boolean(p_buf);
    if api_version() >= 1 then
      l_config.synonym_set := read_rs_describe_configs#synonym_set(p_buf);
    end if;
    return l_config;
  end;
  
  function read_rs_describe_configs#config_set(p_buf in out nocopy te_input_buf) return rs_describe_configs#config_set
  is
    l_size pls_integer;
    l_config_set rs_describe_configs#config_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_config_set(i) := read_rs_describe_configs#config(p_buf);
    end loop;
    return l_config_set;
  end;
  
  function read_rs_describe_configs#result(p_buf in out nocopy te_input_buf) return rs_describe_configs#result
  is
    l_result rs_describe_configs#result;
  begin
    l_result.error_code := read_int(p_buf, c_16bit);
    l_result.error_message := read_string(p_buf);
    l_result.resource_type := read_int(p_buf, c_8bit);
    l_result.resource_name := read_string(p_buf);
    l_result.config_set := read_rs_describe_configs#config_set(p_buf);
    return l_result;
  end;
  
  function read_rs_describe_configs#result_set(p_buf in out nocopy te_input_buf) return rs_describe_configs#result_set
  is
    l_size pls_integer;
    l_result_set rs_describe_configs#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_describe_configs#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_describe_configs(p_buf in out nocopy te_input_buf) return rs_describe_configs
  is
    l_rs_describe_configs rs_describe_configs;
  begin
    buf_init(p_buf);
    l_rs_describe_configs.throttle_time := read_int(p_buf, c_32bit);
    l_rs_describe_configs.result_set := read_rs_describe_configs#result_set(p_buf);
    return l_rs_describe_configs;
  end;
  
  
  -- # Alter configs (33)
  
  procedure put_rq_alter_configs#config(p_buf in out nocopy te_output_buf, p_config in rq_alter_configs#config)
  is
  begin
    put_string(p_buf, p_config.name);
    put_string(p_buf, p_config.value);
  end;
  
  procedure put_rq_alter_configs#config_set(p_buf in out nocopy te_output_buf, p_config_set in rq_alter_configs#config_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_config_set.count, p_len => c_32bit);
    l_i := p_config_set.first;
    loop
      exit when l_i is null;
      put_rq_alter_configs#config(p_buf, p_config_set(l_i));
      l_i := p_config_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_alter_configs#resource(p_buf in out nocopy te_output_buf, p_resource in rq_alter_configs#resource)
  is
  begin
    put_int(p_buf, p_resource.resource_type, c_8bit);
    put_string(p_buf, p_resource.resource_name);
    put_rq_alter_configs#config_set(p_buf, p_resource.config_set);
  end;
  
  procedure put_rq_alter_configs#resource_set(p_buf in out nocopy te_output_buf, p_resource_set in rq_alter_configs#resource_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_resource_set.count, p_len => c_32bit);
    l_i := p_resource_set.first;
    loop
      exit when l_i is null;
      put_rq_alter_configs#resource(p_buf, p_resource_set(l_i));
      l_i := p_resource_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_alter_configs(p_buf in out nocopy te_output_buf, p_rq_alter_configs in rq_alter_configs)
  is
  begin
    put_rq_alter_configs#resource_set(p_buf, p_rq_alter_configs.resource_set);
    put_boolean(p_buf, p_rq_alter_configs.validate_only);
  end;
  
  procedure put_rq_alter_configs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_alter_configs in rq_alter_configs)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_alter_configs, p_rq_header);
    -- Запись запроса.
    put_rq_alter_configs(p_buf, p_rq_alter_configs);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_alter_configs#resource(p_buf in out nocopy te_input_buf) return rs_alter_configs#resource
  is
    l_resource rs_alter_configs#resource;
  begin
    l_resource.error_code := read_int(p_buf, c_16bit);
    l_resource.error_message := read_string(p_buf);
    l_resource.resource_type := read_int(p_buf, c_8bit);
    l_resource.resource_name := read_string(p_buf);
    return l_resource;
  end;
  
  function read_rs_alter_configs#resource_set(p_buf in out nocopy te_input_buf) return rs_alter_configs#resource_set
  is
    l_size pls_integer;
    l_resource_set rs_alter_configs#resource_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_resource_set(i) := read_rs_alter_configs#resource(p_buf);
    end loop;
    return l_resource_set;
  end;
  
  function read_rs_alter_configs(p_buf in out nocopy te_input_buf) return rs_alter_configs
  is
    l_rs_alter_configs rs_alter_configs;
  begin
    buf_init(p_buf);
    l_rs_alter_configs.throttle_time := read_int(p_buf, c_32bit);
    l_rs_alter_configs.resource_set := read_rs_alter_configs#resource_set(p_buf);
    return l_rs_alter_configs;
  end;
  
  
  -- # Alter replica log dirs (34)
  
  procedure put_rq_alter_replica_log_dirs#topic(p_buf in out nocopy te_output_buf, p_topic in rq_alter_replica_log_dirs#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_int_set(p_buf, p_topic.partition_set, c_32bit);
  end;
  
  procedure put_rq_alter_replica_log_dirs#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_alter_replica_log_dirs#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_alter_replica_log_dirs#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_alter_replica_log_dirs#dir(p_buf in out nocopy te_output_buf, p_dir in rq_alter_replica_log_dirs#dir)
  is
  begin
    put_string(p_buf, p_dir.path);
    put_rq_alter_replica_log_dirs#topic_set(p_buf, p_dir.topic_set);
  end;
  
  procedure put_rq_alter_replica_log_dirs#dir_set(p_buf in out nocopy te_output_buf, p_dir_set in rq_alter_replica_log_dirs#dir_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_dir_set.count, p_len => c_32bit);
    l_i := p_dir_set.first;
    loop
      exit when l_i is null;
      put_rq_alter_replica_log_dirs#dir(p_buf, p_dir_set(l_i));
      l_i := p_dir_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_alter_replica_log_dirs(p_buf in out nocopy te_output_buf, p_rq_alter_replica_log_dirs in rq_alter_replica_log_dirs)
  is
  begin
    put_rq_alter_replica_log_dirs#dir_set(p_buf, p_rq_alter_replica_log_dirs.dir_set);
  end;
  
  procedure put_rq_alter_replica_log_dirs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_alter_replica_log_dirs in rq_alter_replica_log_dirs)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_alter_replica_log_dirs, p_rq_header);
    -- Запись запроса.
    put_rq_alter_replica_log_dirs(p_buf, p_rq_alter_replica_log_dirs);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_alter_replica_log_dirs#partition(p_buf in out nocopy te_input_buf) return rs_alter_replica_log_dirs#partition
  is
    l_partition rs_alter_replica_log_dirs#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.error_code := read_int(p_buf, c_16bit);
    return l_partition;
  end;
  
  function read_rs_alter_replica_log_dirs#partition_set(p_buf in out nocopy te_input_buf) return rs_alter_replica_log_dirs#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_alter_replica_log_dirs#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_alter_replica_log_dirs#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_alter_replica_log_dirs#result(p_buf in out nocopy te_input_buf) return rs_alter_replica_log_dirs#result
  is
    l_result rs_alter_replica_log_dirs#result;
  begin
    l_result.topic_name := read_string(p_buf);
    l_result.partition_set := read_rs_alter_replica_log_dirs#partition_set(p_buf);
    return l_result;
  end;
  
  function read_rs_alter_replica_log_dirs#result_set(p_buf in out nocopy te_input_buf) return rs_alter_replica_log_dirs#result_set
  is
    l_size pls_integer;
    l_result_set rs_alter_replica_log_dirs#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_alter_replica_log_dirs#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_alter_replica_log_dirs(p_buf in out nocopy te_input_buf) return rs_alter_replica_log_dirs
  is
    l_rs_alter_replica_log_dirs rs_alter_replica_log_dirs;
  begin
    buf_init(p_buf);
    l_rs_alter_replica_log_dirs.throttle_time := read_int(p_buf, c_32bit);
    l_rs_alter_replica_log_dirs.result_set := read_rs_alter_replica_log_dirs#result_set(p_buf);
    return l_rs_alter_replica_log_dirs;
  end;
  
  
  -- # Describe log dirs (35)
  
  procedure put_rq_describe_log_dirs#topic(p_buf in out nocopy te_output_buf, p_topic in rq_describe_log_dirs#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_int_set(p_buf, p_topic.partition_set, c_32bit);
  end;
  
  procedure put_rq_describe_log_dirs#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_describe_log_dirs#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_describe_log_dirs#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_describe_log_dirs(p_buf in out nocopy te_output_buf, p_rq_describe_log_dirs in rq_describe_log_dirs)
  is
  begin
    put_rq_describe_log_dirs#topic_set(p_buf, p_rq_describe_log_dirs.topic_set);
  end;
  
  procedure put_rq_describe_log_dirs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_log_dirs in rq_describe_log_dirs)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_describe_log_dirs, p_rq_header);
    -- Запись запроса.
    put_rq_describe_log_dirs(p_buf, p_rq_describe_log_dirs);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_describe_log_dirs#partition(p_buf in out nocopy te_input_buf) return rs_describe_log_dirs#partition
  is
    l_partition rs_describe_log_dirs#partition;
  begin
    l_partition.partition_id := read_int(p_buf, c_32bit);
    l_partition.partition_size := read_int64(p_buf);
    l_partition.offset_lag := read_int64(p_buf);
    l_partition.is_future_key := read_boolean(p_buf);
    return l_partition;
  end;
  
  function read_rs_describe_log_dirs#partition_set(p_buf in out nocopy te_input_buf) return rs_describe_log_dirs#partition_set
  is
    l_size pls_integer;
    l_partition_set rs_describe_log_dirs#partition_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_set(i) := read_rs_describe_log_dirs#partition(p_buf);
    end loop;
    return l_partition_set;
  end;
  
  function read_rs_describe_log_dirs#topic(p_buf in out nocopy te_input_buf) return rs_describe_log_dirs#topic
  is
    l_topic rs_describe_log_dirs#topic;
  begin
    l_topic.name := read_string(p_buf);
    l_topic.partition_set := read_rs_describe_log_dirs#partition_set(p_buf);
    return l_topic;
  end;
  
  function read_rs_describe_log_dirs#topic_set(p_buf in out nocopy te_input_buf) return rs_describe_log_dirs#topic_set
  is
    l_size pls_integer;
    l_topic_set rs_describe_log_dirs#topic_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_topic_set(i) := read_rs_describe_log_dirs#topic(p_buf);
    end loop;
    return l_topic_set;
  end;
  
  function read_rs_describe_log_dirs#result(p_buf in out nocopy te_input_buf) return rs_describe_log_dirs#result
  is
    l_result rs_describe_log_dirs#result;
  begin
    l_result.error_code := read_int(p_buf, c_16bit);
    l_result.log_dir := read_string(p_buf);
    l_result.topic_set := read_rs_describe_log_dirs#topic_set(p_buf);
    return l_result;
  end;
  
  function read_rs_describe_log_dirs#result_set(p_buf in out nocopy te_input_buf) return rs_describe_log_dirs#result_set
  is
    l_size pls_integer;
    l_result_set rs_describe_log_dirs#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_describe_log_dirs#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_describe_log_dirs(p_buf in out nocopy te_input_buf) return rs_describe_log_dirs
  is
    l_rs_describe_log_dirs rs_describe_log_dirs;
  begin
    buf_init(p_buf);
    l_rs_describe_log_dirs.throttle_time := read_int(p_buf, c_32bit);
    l_rs_describe_log_dirs.result_set := read_rs_describe_log_dirs#result_set(p_buf);
    return l_rs_describe_log_dirs;
  end;
  
  
  -- # Sasl authenticate (36)
  
  procedure put_rq_sasl_authenticate(p_buf in out nocopy te_output_buf, p_rq_sasl_authenticate in rq_sasl_authenticate)
  is
  begin
    put_data(p_buf, p_rq_sasl_authenticate.auth_bytes);
  end;
  
  procedure put_rq_sasl_authenticate(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_sasl_authenticate in rq_sasl_authenticate)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_sasl_authenticate, p_rq_header);
    -- Запись запроса.
    put_rq_sasl_authenticate(p_buf, p_rq_sasl_authenticate);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_sasl_authenticate(p_buf in out nocopy te_input_buf) return rs_sasl_authenticate
  is
    l_rs_sasl_authenticate rs_sasl_authenticate;
  begin
    buf_init(p_buf);
    l_rs_sasl_authenticate.error_code := read_int(p_buf, c_16bit);
    l_rs_sasl_authenticate.error_message := read_string(p_buf);
    l_rs_sasl_authenticate.auth_bytes := read_data(p_buf);
    l_rs_sasl_authenticate.session_lifetime := read_int64(p_buf);
    return l_rs_sasl_authenticate;
  end;
  
  
  -- # Create partitions (37)
  
  procedure put_rq_create_partitions#assignment(p_buf in out nocopy te_output_buf, p_assignment in rq_create_partitions#assignment)
  is
  begin
    put_int_set(p_buf, p_assignment.broker_set, c_32bit);
  end;
  
  procedure put_rq_create_partitions#assignment_set(p_buf in out nocopy te_output_buf, p_assignment_set in rq_create_partitions#assignment_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_assignment_set.count, p_len => c_32bit);
    l_i := p_assignment_set.first;
    loop
      exit when l_i is null;
      put_rq_create_partitions#assignment(p_buf, p_assignment_set(l_i));
      l_i := p_assignment_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_create_partitions#topic(p_buf in out nocopy te_output_buf, p_topic in rq_create_partitions#topic)
  is
  begin
    put_string(p_buf, p_topic.name);
    put_int(p_buf, p_topic.count, c_32bit);
    put_rq_create_partitions#assignment_set(p_buf, p_topic.assignment_set);
  end;
  
  procedure put_rq_create_partitions#topic_set(p_buf in out nocopy te_output_buf, p_topic_set in rq_create_partitions#topic_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_set.count, p_len => c_32bit);
    l_i := p_topic_set.first;
    loop
      exit when l_i is null;
      put_rq_create_partitions#topic(p_buf, p_topic_set(l_i));
      l_i := p_topic_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_create_partitions(p_buf in out nocopy te_output_buf, p_rq_create_partitions in rq_create_partitions)
  is
  begin
    put_rq_create_partitions#topic_set(p_buf, p_rq_create_partitions.topic_set);
    put_int(p_buf, p_rq_create_partitions.timeout, c_32bit);
    put_boolean(p_buf, p_rq_create_partitions.validate_only);
  end;
  
  procedure put_rq_create_partitions(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_create_partitions in rq_create_partitions)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_create_partitions, p_rq_header);
    -- Запись запроса.
    put_rq_create_partitions(p_buf, p_rq_create_partitions);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
    
  function read_rs_create_partitions#result(p_buf in out nocopy te_input_buf) return rs_create_partitions#result
  is
    l_result rs_create_partitions#result;
  begin
    l_result.name := read_string(p_buf);
    l_result.error_code := read_int(p_buf, c_16bit);
    l_result.error_message := read_string(p_buf);
    return l_result;
  end;
  
  function read_rs_create_partitions#result_set(p_buf in out nocopy te_input_buf) return rs_create_partitions#result_set
  is
    l_size pls_integer;
    l_result_set rs_create_partitions#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_create_partitions#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_create_partitions(p_buf in out nocopy te_input_buf) return rs_create_partitions
  is
    l_rs_create_partitions rs_create_partitions;
  begin
    buf_init(p_buf);
    l_rs_create_partitions.throttle_time := read_int(p_buf, c_32bit);
    l_rs_create_partitions.result_set := read_rs_create_partitions#result_set(p_buf);
    return l_rs_create_partitions;
  end;
  
  
  -- # Create delegation token (38)
  
  procedure put_rq_create_delegation_token#renewer(p_buf in out nocopy te_output_buf, p_renewer in rq_create_delegation_token#renewer)
  is
  begin
    put_string(p_buf, p_renewer.principal_type);
    put_string(p_buf, p_renewer.principal_name);
  end;
  
  procedure put_rq_create_delegation_token#renewer_set(p_buf in out nocopy te_output_buf, p_renewer_set in rq_create_delegation_token#renewer_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_renewer_set.count, p_len => c_32bit);
    l_i := p_renewer_set.first;
    loop
      exit when l_i is null;
      put_rq_create_delegation_token#renewer(p_buf, p_renewer_set(l_i));
      l_i := p_renewer_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_create_delegation_token(p_buf in out nocopy te_output_buf, p_rq_create_delegation_token in rq_create_delegation_token)
  is
  begin
    put_rq_create_delegation_token#renewer_set(p_buf, p_rq_create_delegation_token.renewer_set);
    put_int64(p_buf, p_rq_create_delegation_token.max_lifetime);
  end;
  
  procedure put_rq_create_delegation_token(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_create_delegation_token in rq_create_delegation_token)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_create_delegation_token, p_rq_header);
    -- Запись запроса.
    put_rq_create_delegation_token(p_buf, p_rq_create_delegation_token);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_create_delegation_token(p_buf in out nocopy te_input_buf) return rs_create_delegation_token
  is
    l_rs_create_delegation_token rs_create_delegation_token;
  begin
    buf_init(p_buf);
    l_rs_create_delegation_token.error_code := read_int(p_buf, c_16bit);
    l_rs_create_delegation_token.principal_type := read_string(p_buf);
    l_rs_create_delegation_token.principal_name := read_string(p_buf);
    l_rs_create_delegation_token.issue_timestamp := read_int64(p_buf);
    l_rs_create_delegation_token.expiry_timestamp := read_int64(p_buf);
    l_rs_create_delegation_token.max_timestamp := read_int64(p_buf);
    l_rs_create_delegation_token.token_id := read_string(p_buf);
    l_rs_create_delegation_token.hmac := read_data(p_buf);
    l_rs_create_delegation_token.throttle_time := read_int(p_buf, c_32bit);
    return l_rs_create_delegation_token;
  end;
  
  
  -- # Renew delegation token (39)

  procedure put_rq_renew_delegation_token(p_buf in out nocopy te_output_buf, p_rq_renew_delegation_token in rq_renew_delegation_token)
  is
  begin
    put_data(p_buf, p_rq_renew_delegation_token.hmac);
    put_int64(p_buf, p_rq_renew_delegation_token.renew_period);
  end;
  
  procedure put_rq_renew_delegation_token(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_renew_delegation_token in rq_renew_delegation_token)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_renew_delegation_token, p_rq_header);
    -- Запись запроса.
    put_rq_renew_delegation_token(p_buf, p_rq_renew_delegation_token);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_renew_delegation_token(p_buf in out nocopy te_input_buf) return rs_renew_delegation_token
  is
    l_rs_renew_delegation_token rs_renew_delegation_token;
  begin
    buf_init(p_buf);
    l_rs_renew_delegation_token.error_code := read_int(p_buf, c_16bit);
    l_rs_renew_delegation_token.expiry_timestamp := read_int64(p_buf);
    l_rs_renew_delegation_token.throttle_time := read_int(p_buf, c_32bit);
    return l_rs_renew_delegation_token;
  end;
  
  
  -- # Expire delegation token (40)
  
  procedure put_rq_expire_delegation_token(p_buf in out nocopy te_output_buf, p_rq_expire_delegation_token in rq_expire_delegation_token)
  is
  begin
    put_data(p_buf, p_rq_expire_delegation_token.hmac);
    put_int64(p_buf, p_rq_expire_delegation_token.expiry_time_period);
  end;
  
  procedure put_rq_expire_delegation_token(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_expire_delegation_token in rq_expire_delegation_token)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_expire_delegation_token, p_rq_header);
    -- Запись запроса.
    put_rq_expire_delegation_token(p_buf, p_rq_expire_delegation_token);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_expire_delegation_token(p_buf in out nocopy te_input_buf) return rs_expire_delegation_token
  is
    l_rs_expire_delegation_token rs_expire_delegation_token;
  begin
    buf_init(p_buf);
    l_rs_expire_delegation_token.error_code := read_int(p_buf, c_16bit);
    l_rs_expire_delegation_token.expiry_timestamp := read_int64(p_buf);
    l_rs_expire_delegation_token.throttle_time := read_int(p_buf, c_32bit);
    return l_rs_expire_delegation_token;
  end;
  
  
  -- # Describe delegation token (41)
  
  procedure put_rq_describe_delegation_token#owner(p_buf in out nocopy te_output_buf, p_owner in rq_describe_delegation_token#owner)
  is
  begin
    put_string(p_buf, p_owner.principal_type);
    put_string(p_buf, p_owner.principal_name);
  end;
  
  procedure put_rq_describe_delegation_token#owner_set(p_buf in out nocopy te_output_buf, p_owner_set in rq_describe_delegation_token#owner_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_owner_set.count, p_len => c_32bit);
    l_i := p_owner_set.first;
    loop
      exit when l_i is null;
      put_rq_describe_delegation_token#owner(p_buf, p_owner_set(l_i));
      l_i := p_owner_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_describe_delegation_token(p_buf in out nocopy te_output_buf, p_rq_describe_delegation_token in rq_describe_delegation_token)
  is
  begin
    put_rq_describe_delegation_token#owner_set(p_buf, p_rq_describe_delegation_token.owner_set);
  end;
  
  procedure put_rq_describe_delegation_token(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_describe_delegation_token in rq_describe_delegation_token)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_describe_delegation_token, p_rq_header);
    -- Запись запроса.
    put_rq_describe_delegation_token(p_buf, p_rq_describe_delegation_token);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_describe_delegation_token#renewer(p_buf in out nocopy te_input_buf) return rs_describe_delegation_token#renewer
  is
    l_renewer rs_describe_delegation_token#renewer;
  begin
    l_renewer.principal_type := read_string(p_buf);
    l_renewer.principal_name := read_string(p_buf);
    return l_renewer;
  end;
  
  function read_rs_describe_delegation_token#renewer_set(p_buf in out nocopy te_input_buf) return rs_describe_delegation_token#renewer_set
  is
    l_size pls_integer;
    l_renewer_set rs_describe_delegation_token#renewer_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_renewer_set(i) := read_rs_describe_delegation_token#renewer(p_buf);
    end loop;
    return l_renewer_set;
  end;
  
  function read_rs_describe_delegation_token#token(p_buf in out nocopy te_input_buf) return rs_describe_delegation_token#token
  is
    l_token rs_describe_delegation_token#token;
  begin
    l_token.principal_type := read_string(p_buf);
    l_token.principal_name := read_string(p_buf);
    l_token.issue_timestamp := read_int64(p_buf);
    l_token.expiry_timestamp := read_int64(p_buf);
    l_token.max_timestamp := read_int64(p_buf);
    l_token.token_id := read_string(p_buf);
    l_token.hmac := read_data(p_buf);
    l_token.renewer_set := read_rs_describe_delegation_token#renewer_set(p_buf);
    return l_token;
  end;
  
  function read_rs_describe_delegation_token#token_set(p_buf in out nocopy te_input_buf) return rs_describe_delegation_token#token_set
  is
    l_size pls_integer;
    l_token_set rs_describe_delegation_token#token_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_token_set(i) := read_rs_describe_delegation_token#token(p_buf);
    end loop;
    return l_token_set;
  end;
  
  function read_rs_describe_delegation_token(p_buf in out nocopy te_input_buf) return rs_describe_delegation_token
  is
    l_rs_describe_delegation_token rs_describe_delegation_token;
  begin
    buf_init(p_buf);
    l_rs_describe_delegation_token.error_code := read_int(p_buf, c_16bit);
    l_rs_describe_delegation_token.token_set := read_rs_describe_delegation_token#token_set(p_buf);
    l_rs_describe_delegation_token.throttle_time := read_int(p_buf, c_32bit);
    return l_rs_describe_delegation_token;
  end;
  
  
  -- # Delete groups (42)
  
  procedure put_rq_delete_groups(p_buf in out nocopy te_output_buf, p_rq_delete_groups in rq_delete_groups)
  is
  begin
    put_string_set(p_buf, p_rq_delete_groups.group_name_set);
  end;
  
  procedure put_rq_delete_groups(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_delete_groups in rq_delete_groups)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_delete_groups, p_rq_header);
    -- Запись запроса.
    put_rq_delete_groups(p_buf, p_rq_delete_groups);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_delete_groups#result(p_buf in out nocopy te_input_buf) return rs_delete_groups#result
  is
    l_result rs_delete_groups#result;
  begin
    l_result.group_id := read_string(p_buf);
    l_result.error_code := read_int(p_buf, c_16bit);
    return l_result;
  end;
  
  function read_rs_delete_groups#result_set(p_buf in out nocopy te_input_buf) return rs_delete_groups#result_set
  is
    l_size pls_integer;
    l_result_set rs_delete_groups#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_delete_groups#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_delete_groups(p_buf in out nocopy te_input_buf) return rs_delete_groups
  is
    l_rs_delete_groups rs_delete_groups;
  begin
    buf_init(p_buf);
    l_rs_delete_groups.throttle_time := read_int(p_buf, c_32bit);
    l_rs_delete_groups.result_set := read_rs_delete_groups#result_set(p_buf);
    return l_rs_delete_groups;
  end;
  
  
  -- # Elect preferred leaders (43)
  
  procedure put_rq_elect_preferred_leaders#topic_partition(p_buf in out nocopy te_output_buf, p_topic_partition in rq_elect_preferred_leaders#topic_partition)
  is
  begin
    put_string(p_buf, p_topic_partition.topic);
    put_int_set(p_buf, p_topic_partition.partition_set, c_32bit);
  end;
  
  procedure put_rq_elect_preferred_leaders#topic_partition_set(p_buf in out nocopy te_output_buf, p_topic_partition_set in rq_elect_preferred_leaders#topic_partition_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_topic_partition_set.count, p_len => c_32bit);
    l_i := p_topic_partition_set.first;
    loop
      exit when l_i is null;
      put_rq_elect_preferred_leaders#topic_partition(p_buf, p_topic_partition_set(l_i));
      l_i := p_topic_partition_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_elect_preferred_leaders(p_buf in out nocopy te_output_buf, p_rq_elect_preferred_leaders in rq_elect_preferred_leaders)
  is
  begin
    put_rq_elect_preferred_leaders#topic_partition_set(p_buf, p_rq_elect_preferred_leaders.topic_partition_set);
    put_int(p_buf, p_rq_elect_preferred_leaders.timeout);
  end;
  
  procedure put_rq_elect_preferred_leaders(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_elect_preferred_leaders in rq_elect_preferred_leaders)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_elect_preferred_leaders, p_rq_header);
    -- Запись запроса.
    put_rq_elect_preferred_leaders(p_buf, p_rq_elect_preferred_leaders);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_elect_preferred_leaders#partition_result(p_buf in out nocopy te_input_buf) return rs_elect_preferred_leaders#partition_result
  is
    l_partition_result rs_elect_preferred_leaders#partition_result;
  begin
    l_partition_result.partition_id := read_int(p_buf, c_32bit);
    l_partition_result.error_code := read_int(p_buf, c_16bit);
    l_partition_result.error_message := read_string(p_buf);
    return l_partition_result;
  end;
  
  function read_rs_elect_preferred_leaders#partition_result_set(p_buf in out nocopy te_input_buf) return rs_elect_preferred_leaders#partition_result_set
  is
    l_size pls_integer;
    l_partition_result_set rs_elect_preferred_leaders#partition_result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_partition_result_set(i) := read_rs_elect_preferred_leaders#partition_result(p_buf);
    end loop;
    return l_partition_result_set;
  end;
  
  function read_rs_elect_preferred_leaders#result(p_buf in out nocopy te_input_buf) return rs_elect_preferred_leaders#result
  is
    l_result rs_elect_preferred_leaders#result;
  begin
    l_result.topic := read_string(p_buf);
    l_result.partition_result_set := read_rs_elect_preferred_leaders#partition_result_set(p_buf);
    return l_result;
  end;
  
  function read_rs_elect_preferred_leaders#result_set(p_buf in out nocopy te_input_buf) return rs_elect_preferred_leaders#result_set
  is
    l_size pls_integer;
    l_result_set rs_elect_preferred_leaders#result_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_result_set(i) := read_rs_elect_preferred_leaders#result(p_buf);
    end loop;
    return l_result_set;
  end;
  
  function read_rs_elect_preferred_leaders(p_buf in out nocopy te_input_buf) return rs_elect_preferred_leaders
  is
    l_rs_elect_preferred_leaders rs_elect_preferred_leaders;
  begin
    buf_init(p_buf);
    l_rs_elect_preferred_leaders.throttle_time := read_int(p_buf, c_32bit);
    l_rs_elect_preferred_leaders.result_set := read_rs_elect_preferred_leaders#result_set(p_buf);
    return l_rs_elect_preferred_leaders;
  end;
  
  
  -- # Incremental alter configs (44)
  
  procedure put_rq_incremental_alter_configs#config(p_buf in out nocopy te_output_buf, p_config in rq_incremental_alter_configs#config)
  is
  begin
    put_string(p_buf, p_config.name);
    put_int(p_buf, p_config.config_operation);
    put_string(p_buf, p_config.value);
  end;
  
  procedure put_rq_incremental_alter_configs#config_set(p_buf in out nocopy te_output_buf, p_config_set in rq_incremental_alter_configs#config_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_config_set.count, p_len => c_32bit);
    l_i := p_config_set.first;
    loop
      exit when l_i is null;
      put_rq_incremental_alter_configs#config(p_buf, p_config_set(l_i));
      l_i := p_config_set.next(l_i);
    end loop;
  end;
  
  procedure put_rq_incremental_alter_configs#resource(p_buf in out nocopy te_output_buf, p_resource in rq_incremental_alter_configs#resource)
  is
  begin
    put_int(p_buf, p_resource.resource_type, c_8bit);
    put_string(p_buf, p_resource.resource_name);
    put_rq_incremental_alter_configs#config_set(p_buf, p_resource.config_set);
  end;
  
  procedure put_rq_incremental_alter_configs#resource_set(p_buf in out nocopy te_output_buf, p_resource_set in rq_incremental_alter_configs#resource_set)
  is
    l_i pls_integer;
  begin
    put_int(p_buf, p_resource_set.count, p_len => c_32bit);
    l_i := p_resource_set.first;
    loop
      exit when l_i is null;
      put_rq_incremental_alter_configs#resource(p_buf, p_resource_set(l_i));
      l_i := p_resource_set.next(l_i);
    end loop;
  end;
   
  procedure put_rq_incremental_alter_configs(p_buf in out nocopy te_output_buf, p_rq_incremental_alter_configs in rq_incremental_alter_configs)
  is
  begin
    put_rq_incremental_alter_configs#resource_set(p_buf, p_rq_incremental_alter_configs.resource_set);
    put_boolean(p_buf, p_rq_incremental_alter_configs.validate_only);
  end;
  
  procedure put_rq_incremental_alter_configs(p_buf in out nocopy te_output_buf, p_rq_header in cn_header, p_rq_incremental_alter_configs in rq_incremental_alter_configs)
  is
    l_size pls_integer;
  begin
    buf_init(p_buf);
    -- Размер запроса.
    put_int(p_buf, c_0x00000000);
    -- Запись заголовка.
    put_rq_header(p_buf, ak_rq_incremental_alter_configs, p_rq_header);
    -- Запись запроса.
    put_rq_incremental_alter_configs(p_buf, p_rq_incremental_alter_configs);
    buf_pre_flush(p_buf);
    -- Запись размера запроса.
    l_size := buf_len(p_buf) - c_32bit;
    put_int(p_buf, l_size, p_pos => c_0x00000001);
  end;
  
  function read_rs_incremental_alter_configs#response(p_buf in out nocopy te_input_buf) return rs_incremental_alter_configs#response
  is
    l_response rs_incremental_alter_configs#response;
  begin
    l_response.error_code := read_int(p_buf, c_16bit);
    l_response.error_message := read_string(p_buf);
    l_response.resource_type := read_int(p_buf, c_8bit);
    l_response.resource_name := read_string(p_buf);
    return l_response;
  end;
  
  function read_rs_incremental_alter_configs#response_set(p_buf in out nocopy te_input_buf) return rs_incremental_alter_configs#response_set
  is
    l_size pls_integer;
    l_response_set rs_incremental_alter_configs#response_set;
  begin
    l_size := read_int(p_buf, c_32bit);
    for i in 1 .. l_size loop
      l_response_set(i) := read_rs_incremental_alter_configs#response(p_buf);
    end loop;
    return l_response_set;
  end;
  
  function read_rs_incremental_alter_configs(p_buf in out nocopy te_input_buf) return rs_incremental_alter_configs
  is
    l_rs_incremental_alter_configs rs_incremental_alter_configs;
  begin
    buf_init(p_buf);
    l_rs_incremental_alter_configs.throttle_time := read_int(p_buf, c_32bit);
    l_rs_incremental_alter_configs.response_set := read_rs_incremental_alter_configs#response_set(p_buf);
    return l_rs_incremental_alter_configs;
  end;
  
            
  procedure send(p_con in out nocopy utl_tcp.connection,
                 p_correlation_id in cn_int32,
                 p_buf_rq in te_output_buf, 
                 p_buf_rs out nocopy te_input_buf)
  is
    l_val raw(c_size);
    l_size cn_int32;
    l_correlation_id cn_int32;
    l_buf_size pls_integer;
  begin
    -- Отправка запроса.
    for i in 1 .. p_buf_rq.buf.count loop
      if i < p_buf_rq.buf.count then
        l_size := utl_tcp.write_raw(p_con, p_buf_rq.buf(i), c_size);
      else
        l_size := utl_tcp.write_raw(p_con, p_buf_rq.buf(i));
      end if;
    end loop;
    -- Чтение ответа.
    l_val := utl_tcp.get_raw(p_con, c_32bit);
    l_size := dec_int(l_val) - c_32bit;
    l_val := utl_tcp.get_raw(p_con, c_32bit);
    l_correlation_id := dec_int(l_val);
    if l_correlation_id = p_correlation_id then    
      l_buf_size := ceil(l_size / c_size);
      for i in 1 .. l_buf_size loop
        if l_size >= c_size then
          p_buf_rs.buf(i) := utl_tcp.get_raw(p_con, len => c_size);
          l_size := l_size - c_size;
        elsif l_size > 0 then
          p_buf_rs.buf(i) := utl_tcp.get_raw(p_con, len => l_size);
        end if;
      end loop;
    else
      throw(3, '');
    end if;
  end;
  
  /**
   * Инициализация пакета.
   */
  procedure init
  is
    l_byte raw(1);
  begin
    for i in 0 .. 255 loop
      l_byte := enc_int(i, c_8bit);
      g_int8_t(i) := l_byte;
      g_int8_r_t(rawtohex(l_byte)) := i;
    end loop;
  end;
  
begin
  init;
end;
/
