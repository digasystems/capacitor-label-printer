import { WebPlugin } from '@capacitor/core';

import type {
  CallbackID,
  LabelPrinterPlugin,
  LabelPrinterPrintImageRequest,
  LabelPrinterUnwatchRequest,
  LabelPrinterWatchCallback,
  LabelPrinterWatchRequest,
} from './definitions';

const errorString = 'The plugin is not available on this platform';
const errorFn = Promise.reject(errorString);

export class LabelPrinterWeb extends WebPlugin implements LabelPrinterPlugin {
  printImage(_request: LabelPrinterPrintImageRequest): Promise<any> {
    return errorFn;
  }
  watch(
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _request: LabelPrinterWatchRequest,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _callback: LabelPrinterWatchCallback,
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
