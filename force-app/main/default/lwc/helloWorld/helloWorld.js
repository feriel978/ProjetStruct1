import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'Enter username';
        changeHandler(event) {
        this.greeting = event.target.value;
        }
}