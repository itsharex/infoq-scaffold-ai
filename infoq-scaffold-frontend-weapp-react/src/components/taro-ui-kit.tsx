import { View, Text } from '@tarojs/components';
import type { ReactNode } from 'react';
import {
  AtPagination,
  AtIcon
} from 'taro-ui';

type ActionItem = {
  disabled?: boolean;
  note?: string;
  onClick: () => void;
  title: string;
  danger?: boolean;
};

type KeyValueItem = {
  label: string;
  value: ReactNode;
};

type PaginationBarProps = {
  current: number;
  onChange: (page: number) => void;
  pageSize: number;
  total: number;
};

type StatusTagProps = {
  type?: 'success' | 'error' | 'warning' | 'info';
  label: string;
};

function ActionList({ items }: { items: ActionItem[] }) {
  return (
    <View className="record-footer">
      {items.map((item) => (
        <View
          key={item.title}
          className={`footer-action-btn ${item.danger ? 'danger' : ''} ${item.disabled ? 'disabled' : ''}`}
          onClick={() => {
            if (!item.disabled) {
              item.onClick();
            }
          }}
        >
          {item.title}
        </View>
      ))}
    </View>
  );
}

export function EmptyNotice({ message }: { message: string }) {
  return (
    <View className="empty-notice-container">
      <View className="empty-icon-wrapper">
        <AtIcon value="alert-circle" size="48" color="#bfbfbf" />
      </View>
      <View className="empty-text">{message}</View>
    </View>
  );
}

export function KeyValueList({ items }: { items: KeyValueItem[] }) {
  return (
    <View className="record-body">
      {items.map((item) => (
        <View key={item.label} className="kv-item">
          <Text className="kv-label">{item.label}</Text>
          <View className="kv-value">{item.value}</View>
        </View>
      ))}
    </View>
  );
}

export function PaginationBar({ current, onChange, pageSize, total }: PaginationBarProps) {
  if (total <= pageSize) {
    return null;
  }
  return (
    <View className="pagination-wrapper">
      <AtPagination 
        current={current} 
        icon 
        pageSize={pageSize} 
        total={total} 
        onPageChange={(data) => onChange(data.current)} 
      />
    </View>
  );
}

export function StatusTag({ type = 'info', label }: StatusTagProps) {
  return (
    <View className={`status-tag-modern ${type}`}>
      {label}
    </View>
  );
}

export function RecordCard({ 
  title, 
  icon = 'file-generic',
  extra, 
  children,
  actions,
  statusColor, // Optional color for left accent
  className = ''
}: { 
  title: string; 
  icon?: string;
  extra?: ReactNode; 
  children: ReactNode;
  actions?: ActionItem[];
  statusColor?: string;
  className?: string;
}) {
  return (
    <View className={`record-card-modern ${className}`}>
      {statusColor && <View className="status-accent" style={{ backgroundColor: statusColor }} />}
      <View className="record-header">
        <View className="record-title">
          <AtIcon value={icon} size="16" className="title-icon" />
          <Text className="title-text">{title}</Text>
        </View>
        <View>{extra}</View>
      </View>
      <View className="record-card-body-content">
        {children}
      </View>
      {actions && actions.length > 0 && <ActionList items={actions} />}
    </View>
  );
}

export function FabButton({ icon = 'add', onClick }: { icon?: string; onClick: () => void }) {
  return (
    <View className="fab-button-modern" onClick={onClick}>
      <AtIcon value={icon} size="24" color="#fff" />
    </View>
  );
}
