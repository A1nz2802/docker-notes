import { describe, it } from 'node:test';
import assert from 'node:assert';

import { syncDB } from '../../tasks/sync-db.js';

describe('Pruebas en sync-db', () => {
  it('Debe ejecutar el proceso 4 veces', () => {
    syncDB()
    syncDB()
    syncDB()
    const times = syncDB();
    assert.strictEqual(4,times);
  });

  /* it('Debe ejecutar el proceso 3 veces', () => {
    assert.strictEqual(3,2);
  }); */

});