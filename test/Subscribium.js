const subs = artifacts.require("Subscribium");
const token = artifacts.require("MyToken");

contract('Subscribium', (accounts) => {

    let subsInstance;
    let tokenInstance;
    let publisher;
    let subscriber = accounts[0];
    beforeEach('should setup the contract instance', async () => {
        subsInstance = await subs.deployed();
        tokenInstance = await token.deployed();
        publisher = await subsInstance.publisher();
    });

    it("publisher should be acccounts[9]", async () => {
        console.log("publisher",  publisher);
        console.log("accounts",  accounts[9]);
        console.log("res",  accounts[9] == publisher);
        assert.equal(publisher, accounts[9], "not publisher");
    });

    it("should add #0 account to subscribers", async () => {
        const interval = 111;
        const value = 222;
        await tokenInstance.approve(subsInstance.address, 1000)
        await subsInstance.Subscribe(interval, value)

        const subscribers = await subsInstance.subscribers;
        const subscription = await subscribers(subscriber);
        console.log("subsInstance.subscribers",  subscription.interval.words[0]);

        assert.equal(subscription.interval.words[0], interval, 'interval is false');
        assert.equal(subscription.value.words[0], value, 'value is false');
    });

    it("should pay only on duedate", async () => {
        const subscribers = await subsInstance.subscribers;
        const subscription = await subscribers(subscriber);
        
        const interval = subscription.interval.words[0];
        const value = subscription.value.words[0];

        let balanceBefore = await tokenInstance.balanceOf(subscriber)
        let result = await subsInstance.ExecuteSubscription(subscriber);
        let balanceAfter = await tokenInstance.balanceOf(subscriber);
        assert.equal(balanceBefore.words[0] - value, balanceAfter.words[0], "subscription executed 1");
        
        balanceBefore = balanceAfter
        try {
            result = await subsInstance.ExecuteSubscription(subscriber);
        } catch (e) {}
        assert.equal(balanceBefore.words[0], balanceAfter.words[0], "subscription executed 2");
    });
});