defmodule(Thrift.Hive.TCLIService.Handler) do
  @callback(cancel_delegation_token(req :: %Thrift.Hive.TCancelDelegationTokenReq{}) :: %Thrift.Hive.TCancelDelegationTokenResp{})
  @callback(cancel_operation(req :: %Thrift.Hive.TCancelOperationReq{}) :: %Thrift.Hive.TCancelOperationResp{})
  @callback(close_operation(req :: %Thrift.Hive.TCloseOperationReq{}) :: %Thrift.Hive.TCloseOperationResp{})
  @callback(close_session(req :: %Thrift.Hive.TCloseSessionReq{}) :: %Thrift.Hive.TCloseSessionResp{})
  @callback(execute_statement(req :: %Thrift.Hive.TExecuteStatementReq{}) :: %Thrift.Hive.TExecuteStatementResp{})
  @callback(fetch_results(req :: %Thrift.Hive.TFetchResultsReq{}) :: %Thrift.Hive.TFetchResultsResp{})
  @callback(get_catalogs(req :: %Thrift.Hive.TGetCatalogsReq{}) :: %Thrift.Hive.TGetCatalogsResp{})
  @callback(get_columns(req :: %Thrift.Hive.TGetColumnsReq{}) :: %Thrift.Hive.TGetColumnsResp{})
  @callback(get_delegation_token(req :: %Thrift.Hive.TGetDelegationTokenReq{}) :: %Thrift.Hive.TGetDelegationTokenResp{})
  @callback(get_functions(req :: %Thrift.Hive.TGetFunctionsReq{}) :: %Thrift.Hive.TGetFunctionsResp{})
  @callback(get_info(req :: %Thrift.Hive.TGetInfoReq{}) :: %Thrift.Hive.TGetInfoResp{})
  @callback(get_operation_status(req :: %Thrift.Hive.TGetOperationStatusReq{}) :: %Thrift.Hive.TGetOperationStatusResp{})
  @callback(get_result_set_metadata(req :: %Thrift.Hive.TGetResultSetMetadataReq{}) :: %Thrift.Hive.TGetResultSetMetadataResp{})
  @callback(get_schemas(req :: %Thrift.Hive.TGetSchemasReq{}) :: %Thrift.Hive.TGetSchemasResp{})
  @callback(get_table_types(req :: %Thrift.Hive.TGetTableTypesReq{}) :: %Thrift.Hive.TGetTableTypesResp{})
  @callback(get_tables(req :: %Thrift.Hive.TGetTablesReq{}) :: %Thrift.Hive.TGetTablesResp{})
  @callback(get_type_info(req :: %Thrift.Hive.TGetTypeInfoReq{}) :: %Thrift.Hive.TGetTypeInfoResp{})
  @callback(open_session(req :: %Thrift.Hive.TOpenSessionReq{}) :: %Thrift.Hive.TOpenSessionResp{})
  @callback(renew_delegation_token(req :: %Thrift.Hive.TRenewDelegationTokenReq{}) :: %Thrift.Hive.TRenewDelegationTokenResp{})
end