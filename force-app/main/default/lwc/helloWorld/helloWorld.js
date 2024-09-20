import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'Enter UserName';
        changeHandler(event) {
        this.greeting = event.target.value;
        }
}