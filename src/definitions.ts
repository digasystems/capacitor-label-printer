import type { PluginListenerHandle } from '@capacitor/core';

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

export interface LabelPrinterUnregisterRequest extends LabelPrinterWatchRequest {
  name: string;
}

export interface LabelPrinterRegisterRequest extends LabelPrinterUnregisterRequest {
  port: number;
  props: { [key: string]: string };
}

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
  addListener(eventName: 'discover', listenerFunc: (result: LabelPrinterWatchResult) => void): PluginListenerHandle;
  getHostname(): Promise<{ hostname: string }>;
  printImage(_request: LabelPrinterPrintImageRequest): Promise<void>;
  register(request: LabelPrinterRegisterRequest): Promise<void>;
  unregister(request: LabelPrinterUnregisterRequest): Promise<void>;
  stop(): Promise<void>;
  watch(request: LabelPrinterWatchRequest, callback?: LabelPrinterWatchCallback): Promise<CallbackID>;
  unwatch(request: LabelPrinterUnwatchRequest): Promise<void>;
  close(): Promise<void>;
}