%% Automatically generated, do not edit
%% Generated by gpb_compile version 3.22.2 on {{2016,6,13},{12,17,0}}

-ifndef(pb_msync).
-define(pb_msync, true).

-define(pb_msync_gpb_version, "3.22.2").

-ifndef('JID_PB_H').
-define('JID_PB_H', true).
-record('JID',
        {app_key,                       % = 1, string (optional)
         name,                          % = 2, string (optional)
         domain,                        % = 3, string (optional)
         client_resource                % = 4, string (optional)
        }).
-endif.

-ifndef('METAQUEUE_PB_H').
-define('METAQUEUE_PB_H', true).
-record('MetaQueue',
        {queue,                         % = 1, {msg,'JID'} (optional)
         n                              % = 2, uint32 (optional)
        }).
-endif.

-ifndef('META_PB_H').
-define('META_PB_H', true).
-record('Meta',
        {id,                            % = 1, uint64 (optional)
         from,                          % = 2, {msg,'JID'} (optional)
         to,                            % = 3, {msg,'JID'} (optional)
         timestamp,                     % = 4, uint64 (optional)
         ns,                            % = 5, {enum,'Meta.NameSpace'} (optional)
         payload                        % = 6, bytes (optional)
        }).
-endif.

-ifndef('COMMSYNCUL_PB_H').
-define('COMMSYNCUL_PB_H', true).
-record('CommSyncUL',
        {meta,                          % = 1, {msg,'Meta'} (optional)
         key,                           % = 2, uint64 (optional)
         queue                          % = 3, {msg,'JID'} (optional)
        }).
-endif.

-ifndef('COMMUNREADUL_PB_H').
-define('COMMUNREADUL_PB_H', true).
-record('CommUnreadUL',
        {
        }).
-endif.

-ifndef('COMMNOTICE_PB_H').
-define('COMMNOTICE_PB_H', true).
-record('CommNotice',
        {queue                          % = 1, {msg,'JID'} (optional)
        }).
-endif.

-ifndef('REDIRECTINFO_PB_H').
-define('REDIRECTINFO_PB_H', true).
-record('RedirectInfo',
        {host,                          % = 1, string (optional)
         port                           % = 2, uint32 (optional)
        }).
-endif.

-ifndef('STATUS_PB_H').
-define('STATUS_PB_H', true).
-record('Status',
        {error_code,                    % = 1, {enum,'Status.ErrorCode'} (optional)
         reason,                        % = 2, string (optional)
         redirect_info = []             % = 3, [{msg,'RedirectInfo'}]
        }).
-endif.

-ifndef('PROVISION_PB_H').
-define('PROVISION_PB_H', true).
-record('Provision',
        {os_type,                       % = 1, {enum,'Provision.OsType'} (optional)
         version,                       % = 2, string (optional)
         network_type,                  % = 3, {enum,'Provision.NetworkType'} (optional)
         app_sign,                      % = 4, string (optional)
         compress_type = [],            % = 5, [{enum,'Provision.CompressType'}]
         encrypt_type = [],             % = 6, [{enum,'Provision.EncryptType'}]
         encrypt_key,                   % = 7, string (optional)
         status                         % = 8, {msg,'Status'} (optional)
        }).
-endif.

-ifndef('COMMSYNCDL_PB_H').
-define('COMMSYNCDL_PB_H', true).
-record('CommSyncDL',
        {status,                        % = 1, {msg,'Status'} (optional)
         meta_id,                       % = 2, uint64 (optional)
         server_id,                     % = 3, uint64 (optional)
         metas = [],                    % = 4, [{msg,'Meta'}]
         next_key,                      % = 5, uint64 (optional)
         queue,                         % = 6, {msg,'JID'} (optional)
         is_last                        % = 7, bool (optional)
        }).
-endif.

-ifndef('COMMUNREADDL_PB_H').
-define('COMMUNREADDL_PB_H', true).
-record('CommUnreadDL',
        {status,                        % = 1, {msg,'Status'} (optional)
         unread = []                    % = 2, [{msg,'MetaQueue'}]
        }).
-endif.

-ifndef('MSYNC_PB_H').
-define('MSYNC_PB_H', true).
-record('MSync',
        {version = 'MSYNC_V1',          % = 1, {enum,'MSync.Version'} (optional)
         guid,                          % = 2, {msg,'JID'} (optional)
         auth,                          % = 3, string (optional)
         compress_algorimth,            % = 4, uint32 (optional)
         crypto,                        % = 5, uint32 (optional)
         user_agent,                    % = 6, string (optional)
         pov,                           % = 7, uint64 (optional)
         command,                       % = 8, {enum,'MSync.Command'} (optional)
         device_id,                     % = 10, uint32 (optional)
         payload                        % = 9, bytes (optional)
        }).
-endif.

-endif.