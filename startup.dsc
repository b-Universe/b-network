server_start_handler:
  type: world
  debug: false
  events:
    after server start:
      - adjust system redirect_logging:true
