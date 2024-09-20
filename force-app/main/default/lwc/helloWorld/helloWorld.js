import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'enter';
        changeHandler(event) {
        this.greeting = event.target.value;
        }
}