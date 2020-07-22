const puppeteer = require('puppeteer-extra'),
  stealthPlugin = require('puppeteer-extra-plugin-stealth'),
  waitForXSec = require('./helpers').waitForXSec,
  meetings = require('./assets').meetings,
  HEADLESS = false;
  VERBOSE = true,
  GOOGLE_LOGIN = 'https://accounts.google.com/signin/v2/identifier?flowName=GlifWebSignIn&flowEntry=ServiceLogin';

require('dotenv').config();
puppeteer.use(stealthPlugin());

function Gmeet() {
  this.browser = null;
}

/**
 * method to join meeting through puppeteer
 * 
 */
Gmeet.prototype.join = async function (lecNum) {
  if (this.browser != null) {
    await this.browser.close();
    this.browser = null;
  }
  let page,
    failed = false,
    joined = false,
    attempt = 0;
  this.page = null;
    do {
      attempt++;
      try {
        this.browser = await puppeteer.launch({
          headless: HEADLESS,
          args: ['--use-fake-ui-for-media-stream', '--disable-audio-output']
        });
        this.page = await this.browser.newPage();
        await this.page.goto(GOOGLE_LOGIN);
        if (VERBOSE) console.log("[VERBOSE] Inputting username");
        await this.page.type("input#identifierId", process.env.EMAIL, {
          delay: 0
        });
        await this.page.click('div#identifierNext');
        if (VERBOSE) console.log("[VERBOSE] Clicked the next button");
        await waitForXSec(3);
        if (VERBOSE) console.log("[VERBOSE] Inputting password");
        await this.page.type("input.whsOnd.zHQkBf", process.env.PASSWORD, {
          delay: 0
        });
        await this.page.click("div#passwordNext");
        if (VERBOSE) console.log("[VERBOSE] Clicked the next button");
        await waitForXSec(5);
        await this.page.goto(meetings.MONDAY[lecNum]);
        await waitForXSec(5);
        await this.page.click("span.NPEfkd.RveJvd.snByac");
        console.log("Successfully joined/Sent join request");
        joined = true;
      } catch (err) {
        Gmeet.prototype.close();
        if (attempt > 5) {
          failed = true;
          console.log("incorrect username or password provided");
          return {error: err, status: false};
        }
      }
    } while (!failed && !joined);
    return {error: null, status: true};
};


/**
 * method to send message through puppeteer
 */
Gmeet.prototype.message = async function (message) {
  try {
    await this.page.click("div.HKarue");
    await this.page.type("textarea.KHxj8b.tL9Q4c", message);
    await this.page.keyboard.press('Enter');
    // await this.page.click('div.uArJ5e Y5FYJe cjq2Db HZJnJ Cs0vCd RDPZE')
  } catch (error) {
    console.log(error);
  }
}

Gmeet.prototype.close = async function () {
  if(this.page){
    try {
      await this.browser.close();
      this.browser = null;
    }
    catch (error) {
      return {error, status: false};
    }
  }
  return {error: null, status:true};
}

module.exports = Gmeet;