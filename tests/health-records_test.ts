import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensures health data can be added and retrieved",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("health-records", "add-health-data",
        [types.uint(75), types.uint(120), types.uint(37)],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    const result = chain.callReadOnlyFn(
      "health-records",
      "get-health-data",
      [types.principal(wallet_1.address)],
      wallet_1.address
    );
    
    result.result.expectOk().expectSome();
  },
});
