import { PluginListenerHandle } from '@capacitor/core';

export type CallbackID = string;

export interface LabelPrinterPrintImageRequest {
  ip: string;
  image: string;
  printer: string;
  label: string;
}

export interface LabelPrinterWatchRequest {
  type: string;
  domain: string;
}

export type LabelPrinterUnwatchRequest = LabelPrinterWatchRequest;

export interface LabelPrinterService {
  domain: string;
  type: string;
  name: string;
  port: number;
  hostname: string;
  ipv4Addresses: string[];
  ipv6Addresses: string[];
  txtRecord: { [key: string]: string };
}

export type LabelPrinterWatchAction = 'added' | 'removed' | 'resolved';
export type LabelPrinterWatchResult = {
  action: LabelPrinterWatchAction;
  service: LabelPrinterService;
};
export type LabelPrinterWatchCallback = (event: LabelPrinterWatchResult) => void;

export interface LabelPrinterPlugin {
  printImage(_request: LabelPrinterPrintImageRequest): Promise<void>;
  watch(request: LabelPrinterWatchRequest, callback?: LabelPrinterWatchCallback): Promise<CallbackID>;
  unwatch(request: LabelPrinterUnwatchRequest): Promise<void>;
  close(): Promise<void>;
  addListener(
    eventName: 'serviceDiscovered',
    listenerFunc: (orientation: LabelPrinterWatchResult) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  removeAllListeners(): Promise<void>;
}
