import { WebPlugin } from '@capacitor/core';

import type { LabelPrinterPlugin } from './definitions';

export class LabelPrinterWeb extends WebPlugin implements LabelPrinterPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
