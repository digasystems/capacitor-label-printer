import { WebPlugin } from '@capacitor/core';

import type {
  CallbackID,
  LabelPrinterPlugin,
  LabelPrinterRegisterRequest,
  LabelPrinterUnregisterRequest,
  LabelPrinterUnwatchRequest,
  LabelPrinterWatchCallback,
  LabelPrinterWatchRequest,
} from './definitions';

const errorString = 'The plugin is not available on this platform';
const errorFn = Promise.reject(errorString);

export class LabelPrinterWeb extends WebPlugin implements LabelPrinterPlugin {
  getHostname(): Promise<{ hostname: string }> {
    return errorFn;
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  register(_request: LabelPrinterRegisterRequest): Promise<void> {
    return errorFn;
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  unregister(_request: LabelPrinterUnregisterRequest): Promise<void> {
    return errorFn;
  }
  stop(): Promise<void> {
    return errorFn;
  }
  watch(
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _request: LabelPrinterWatchRequest,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _callback: LabelPrinterWatchCallback
  ): Promise<CallbackID> {
    return errorFn;
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  unwatch(_request: LabelPrinterUnwatchRequest): Promise<void> {
    return errorFn;
  }
  close(): Promise<void> {
    return errorFn;
  }
}