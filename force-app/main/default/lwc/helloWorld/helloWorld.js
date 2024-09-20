import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'Enter';
        changeHandler(event) {
        this.greeting = event.target.value;
        }
}