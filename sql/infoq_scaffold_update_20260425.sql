SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `sys_job` (
    `job_id` bigint NOT NULL COMMENT '任务ID',
    `job_name` varchar(128) NOT NULL COMMENT '任务名称',
    `job_group` varchar(64) NOT NULL COMMENT '任务分组',
    `handler_key` varchar(128) NOT NULL COMMENT '处理器标识',
    `handler_params` text COMMENT '处理器参数(JSON对象)',
    `cron_expression` varchar(255) NOT NULL COMMENT 'Cron表达式',
    `misfire_policy` char(1) NOT NULL DEFAULT '0' COMMENT '错过策略（0默认 1立即补跑 2触发后继续 3忽略本次）',
    `concurrent` char(1) NOT NULL DEFAULT '1' COMMENT '并发策略（0允许 1禁止）',
    `status` char(1) NOT NULL DEFAULT '1' COMMENT '状态（0正常 1暂停）',
    `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0存在 1删除）',
    `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
    `create_by` bigint DEFAULT NULL COMMENT '创建者',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_by` bigint DEFAULT NULL COMMENT '更新者',
    `update_time` datetime DEFAULT NULL COMMENT '更新时间',
    `remark` varchar(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`job_id`) USING BTREE,
    KEY `idx_sys_job_group_status` (`job_group`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务表';

CREATE TABLE IF NOT EXISTS `sys_job_log` (
    `job_log_id` bigint NOT NULL COMMENT '任务日志ID',
    `job_id` bigint NOT NULL COMMENT '任务ID',
    `job_name` varchar(128) NOT NULL COMMENT '任务名称',
    `job_group` varchar(64) NOT NULL COMMENT '任务分组',
    `handler_key` varchar(128) NOT NULL COMMENT '处理器标识',
    `handler_params` text COMMENT '处理器参数(JSON对象)',
    `trigger_source` varchar(32) NOT NULL COMMENT '触发来源',
    `job_message` varchar(1000) DEFAULT NULL COMMENT '执行消息',
    `status` char(1) NOT NULL DEFAULT '0' COMMENT '执行状态（0成功 1失败）',
    `exception_info` text COMMENT '异常信息',
    `duration_ms` bigint DEFAULT NULL COMMENT '耗时毫秒',
    `start_time` datetime DEFAULT NULL COMMENT '开始时间',
    `end_time` datetime DEFAULT NULL COMMENT '结束时间',
    PRIMARY KEY (`job_log_id`) USING BTREE,
    KEY `idx_sys_job_log_job_id` (`job_id`),
    KEY `idx_sys_job_log_status_start` (`status`, `start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务日志表';

CREATE TABLE IF NOT EXISTS `QRTZ_JOB_DETAILS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `JOB_NAME` varchar(200) NOT NULL COMMENT '任务名称',
    `JOB_GROUP` varchar(200) NOT NULL COMMENT '任务分组',
    `DESCRIPTION` varchar(250) DEFAULT NULL COMMENT '任务描述',
    `JOB_CLASS_NAME` varchar(250) NOT NULL COMMENT 'Quartz任务执行类全名',
    `IS_DURABLE` varchar(1) NOT NULL COMMENT '是否持久化（0否 1是）',
    `IS_NONCONCURRENT` varchar(1) NOT NULL COMMENT '是否禁止并发执行（0否 1是）',
    `IS_UPDATE_DATA` varchar(1) NOT NULL COMMENT '执行后是否更新JobData',
    `REQUESTS_RECOVERY` varchar(1) NOT NULL COMMENT '调度恢复后是否重新执行',
    `JOB_DATA` blob COMMENT '任务数据',
    PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz任务明细表';

CREATE TABLE IF NOT EXISTS `QRTZ_TRIGGERS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `TRIGGER_NAME` varchar(200) NOT NULL COMMENT '触发器名称',
    `TRIGGER_GROUP` varchar(200) NOT NULL COMMENT '触发器分组',
    `JOB_NAME` varchar(200) NOT NULL COMMENT '关联任务名称',
    `JOB_GROUP` varchar(200) NOT NULL COMMENT '关联任务分组',
    `DESCRIPTION` varchar(250) DEFAULT NULL COMMENT '触发器描述',
    `NEXT_FIRE_TIME` bigint DEFAULT NULL COMMENT '下一次触发时间戳',
    `PREV_FIRE_TIME` bigint DEFAULT NULL COMMENT '上一次触发时间戳',
    `PRIORITY` int DEFAULT NULL COMMENT '触发优先级',
    `TRIGGER_STATE` varchar(16) NOT NULL COMMENT '触发器状态',
    `TRIGGER_TYPE` varchar(8) NOT NULL COMMENT '触发器类型',
    `START_TIME` bigint NOT NULL COMMENT '开始生效时间戳',
    `END_TIME` bigint DEFAULT NULL COMMENT '结束时间戳',
    `CALENDAR_NAME` varchar(200) DEFAULT NULL COMMENT '日历名称',
    `MISFIRE_INSTR` smallint DEFAULT NULL COMMENT 'misfire处理指令',
    `JOB_DATA` blob COMMENT '触发器数据',
    PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
    KEY `idx_qrtz_t_j` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
    CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
        REFERENCES `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz触发器表';

CREATE TABLE IF NOT EXISTS `QRTZ_SIMPLE_TRIGGERS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `TRIGGER_NAME` varchar(200) NOT NULL COMMENT '触发器名称',
    `TRIGGER_GROUP` varchar(200) NOT NULL COMMENT '触发器分组',
    `REPEAT_COUNT` bigint NOT NULL COMMENT '重复次数',
    `REPEAT_INTERVAL` bigint NOT NULL COMMENT '重复间隔毫秒',
    `TIMES_TRIGGERED` bigint NOT NULL COMMENT '已触发次数',
    PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
    CONSTRAINT `QRTZ_SIMPLE_TRIG_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
        REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz简单触发器表';

CREATE TABLE IF NOT EXISTS `QRTZ_CRON_TRIGGERS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `TRIGGER_NAME` varchar(200) NOT NULL COMMENT '触发器名称',
    `TRIGGER_GROUP` varchar(200) NOT NULL COMMENT '触发器分组',
    `CRON_EXPRESSION` varchar(200) NOT NULL COMMENT 'Cron表达式',
    `TIME_ZONE_ID` varchar(80) DEFAULT NULL COMMENT '时区ID',
    PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
    CONSTRAINT `QRTZ_CRON_TRIG_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
        REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz Cron触发器表';

CREATE TABLE IF NOT EXISTS `QRTZ_SIMPROP_TRIGGERS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `TRIGGER_NAME` varchar(200) NOT NULL COMMENT '触发器名称',
    `TRIGGER_GROUP` varchar(200) NOT NULL COMMENT '触发器分组',
    `STR_PROP_1` varchar(512) DEFAULT NULL COMMENT '字符串属性1',
    `STR_PROP_2` varchar(512) DEFAULT NULL COMMENT '字符串属性2',
    `STR_PROP_3` varchar(512) DEFAULT NULL COMMENT '字符串属性3',
    `INT_PROP_1` int DEFAULT NULL COMMENT '整型属性1',
    `INT_PROP_2` int DEFAULT NULL COMMENT '整型属性2',
    `LONG_PROP_1` bigint DEFAULT NULL COMMENT '长整型属性1',
    `LONG_PROP_2` bigint DEFAULT NULL COMMENT '长整型属性2',
    `DEC_PROP_1` numeric(13,4) DEFAULT NULL COMMENT '小数属性1',
    `DEC_PROP_2` numeric(13,4) DEFAULT NULL COMMENT '小数属性2',
    `BOOL_PROP_1` varchar(1) DEFAULT NULL COMMENT '布尔属性1',
    `BOOL_PROP_2` varchar(1) DEFAULT NULL COMMENT '布尔属性2',
    PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
    CONSTRAINT `QRTZ_SIMPROP_TRIG_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
        REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz扩展属性触发器表';

CREATE TABLE IF NOT EXISTS `QRTZ_BLOB_TRIGGERS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `TRIGGER_NAME` varchar(200) NOT NULL COMMENT '触发器名称',
    `TRIGGER_GROUP` varchar(200) NOT NULL COMMENT '触发器分组',
    `BLOB_DATA` blob COMMENT '二进制触发器数据',
    PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
    CONSTRAINT `QRTZ_BLOB_TRIG_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
        REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz二进制触发器表';

CREATE TABLE IF NOT EXISTS `QRTZ_CALENDARS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `CALENDAR_NAME` varchar(200) NOT NULL COMMENT '日历名称',
    `CALENDAR` blob NOT NULL COMMENT '日历序列化数据',
    PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz日历表';

CREATE TABLE IF NOT EXISTS `QRTZ_PAUSED_TRIGGER_GRPS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `TRIGGER_GROUP` varchar(200) NOT NULL COMMENT '已暂停的触发器分组',
    PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz暂停触发器分组表';

CREATE TABLE IF NOT EXISTS `QRTZ_FIRED_TRIGGERS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `ENTRY_ID` varchar(95) NOT NULL COMMENT '已触发记录ID',
    `TRIGGER_NAME` varchar(200) NOT NULL COMMENT '触发器名称',
    `TRIGGER_GROUP` varchar(200) NOT NULL COMMENT '触发器分组',
    `INSTANCE_NAME` varchar(200) NOT NULL COMMENT '调度实例名称',
    `FIRED_TIME` bigint NOT NULL COMMENT '实际触发时间戳',
    `SCHED_TIME` bigint NOT NULL COMMENT '计划触发时间戳',
    `PRIORITY` int NOT NULL COMMENT '优先级',
    `STATE` varchar(16) NOT NULL COMMENT '触发状态',
    `JOB_NAME` varchar(200) DEFAULT NULL COMMENT '任务名称',
    `JOB_GROUP` varchar(200) DEFAULT NULL COMMENT '任务分组',
    `IS_NONCONCURRENT` varchar(1) DEFAULT NULL COMMENT '是否禁止并发执行',
    `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL COMMENT '是否请求恢复执行',
    PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz已触发触发器表';

CREATE TABLE IF NOT EXISTS `QRTZ_SCHEDULER_STATE` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `INSTANCE_NAME` varchar(200) NOT NULL COMMENT '调度实例名称',
    `LAST_CHECKIN_TIME` bigint NOT NULL COMMENT '最后一次心跳检查时间戳',
    `CHECKIN_INTERVAL` bigint NOT NULL COMMENT '心跳检查间隔毫秒',
    PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz调度器状态表';

CREATE TABLE IF NOT EXISTS `QRTZ_LOCKS` (
    `SCHED_NAME` varchar(120) NOT NULL COMMENT '调度器名称',
    `LOCK_NAME` varchar(40) NOT NULL COMMENT '锁名称',
    PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quartz锁表';

INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042501, '任务状态', 'sys_job_status', 103, 1, NOW(), 1, NOW(), '定时任务状态'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type` = 'sys_job_status');

INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042502, '任务分组', 'sys_job_group', 103, 1, NOW(), 1, NOW(), '定时任务分组'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type` = 'sys_job_group');

INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042503, '错过策略', 'sys_job_misfire_policy', 103, 1, NOW(), 1, NOW(), 'Quartz 错过策略'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type` = 'sys_job_misfire_policy');

INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042504, '并发策略', 'sys_job_concurrent', 103, 1, NOW(), 1, NOW(), 'Quartz 并发策略'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_type` = 'sys_job_concurrent');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250101, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', 103, 1, NOW(), 1, NOW(), '任务启用'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_status' AND `dict_value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250102, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', 103, 1, NOW(), 1, NOW(), '任务暂停'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_status' AND `dict_value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250201, 1, '系统任务', 'SYSTEM', 'sys_job_group', '', 'primary', 'Y', 103, 1, NOW(), 1, NOW(), '系统托管任务'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_group' AND `dict_value` = 'SYSTEM');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250301, 1, '默认策略', '0', 'sys_job_misfire_policy', '', 'default', 'Y', 103, 1, NOW(), 1, NOW(), '默认处理'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_misfire_policy' AND `dict_value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250302, 2, '忽略错过', '1', 'sys_job_misfire_policy', '', 'warning', 'N', 103, 1, NOW(), 1, NOW(), '忽略所有错过'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_misfire_policy' AND `dict_value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250303, 3, '立即补跑', '2', 'sys_job_misfire_policy', '', 'success', 'N', 103, 1, NOW(), 1, NOW(), '立刻执行一次再继续'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_misfire_policy' AND `dict_value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250304, 4, '跳过本次', '3', 'sys_job_misfire_policy', '', 'info', 'N', 103, 1, NOW(), 1, NOW(), '跳过错过的触发'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_misfire_policy' AND `dict_value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250401, 1, '允许并发', '0', 'sys_job_concurrent', '', 'success', 'Y', 103, 1, NOW(), 1, NOW(), '允许并发执行'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_concurrent' AND `dict_value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 202604250402, 2, '禁止并发', '1', 'sys_job_concurrent', '', 'danger', 'N', 103, 1, NOW(), 1, NOW(), '串行执行'
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_type` = 'sys_job_concurrent' AND `dict_value` = '1');

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042510, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 103, 1, NOW(), 1, NOW(), '定时任务菜单'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042510);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042520, '任务日志', 2, 3, 'jobLog', 'monitor/jobLog/index', '', 1, 0, 'C', '0', '0', 'monitor:jobLog:list', 'form', 103, 1, NOW(), 1, NOW(), '定时任务日志菜单'
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042520);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042511, '任务查询', 2026042510, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042511);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042512, '任务新增', 2026042510, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042512);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042513, '任务修改', 2026042510, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042513);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042514, '任务删除', 2026042510, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042514);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042515, '任务导出', 2026042510, 5, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042515);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042516, '状态切换', 2026042510, 6, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042516);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042517, '立即执行', 2026042510, 7, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:run', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042517);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042521, '日志查询', 2026042520, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:jobLog:query', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042521);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042522, '日志删除', 2026042520, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:jobLog:remove', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042522);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042523, '日志导出', 2026042520, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:jobLog:export', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042523);

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 2026042524, '日志清空', 2026042520, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:jobLog:remove', '#', 103, 1, NOW(), 1, NOW(), ''
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_id` = 2026042524);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, menu_id FROM `sys_menu`
WHERE menu_id IN (
    2026042510, 2026042520, 2026042511, 2026042512, 2026042513, 2026042514,
    2026042515, 2026042516, 2026042517, 2026042521, 2026042522, 2026042523, 2026042524
) AND NOT EXISTS (
    SELECT 1 FROM `sys_role_menu` rm WHERE rm.role_id = 1 AND rm.menu_id = `sys_menu`.menu_id
);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 3, menu_id FROM `sys_menu`
WHERE menu_id IN (
    2026042510, 2026042520, 2026042511, 2026042521
) AND NOT EXISTS (
    SELECT 1 FROM `sys_role_menu` rm WHERE rm.role_id = 3 AND rm.menu_id = `sys_menu`.menu_id
);

INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `handler_key`, `handler_params`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 20260425001, '调度演示任务', 'SYSTEM', 'system.noop', '{"source":"bootstrap"}', '0 0/30 * * * ?', '0', '1', '1', '0', 103, 1, NOW(), 1, NOW(), '默认演示任务，创建后处于暂停状态'
WHERE NOT EXISTS (SELECT 1 FROM `sys_job` WHERE `job_id` = 20260425001);

SET FOREIGN_KEY_CHECKS = 1;
