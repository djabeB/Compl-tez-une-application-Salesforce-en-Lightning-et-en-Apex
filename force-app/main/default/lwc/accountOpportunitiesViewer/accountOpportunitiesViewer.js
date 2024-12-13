import { LightningElement, api, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/AccountOpportunitiesController.getOpportunities';
import { refreshApex } from '@salesforce/apex';

export default class AccountOpportunitiesViewer extends LightningElement {
    @api recordId;
    @track opportunities;
    @track error = {};
    wiredOpportunitiesResult;
    columns = [
        { label: 'Nom Opportunité', fieldName: 'Name', type: 'text' },
        { label: 'Montant', fieldName: 'Amount', type: 'currency' },
        { label: 'Date de Clôture', fieldName: 'CloseDate', type: 'date' },
        { label: 'Phase', fieldName: 'StageName', type: 'text' }
    ];

    @wire(getOpportunities, { accountId: '$recordId' })
    wiredOpportunities(result) {
        if (result) { // Vérifie si result existe
            this.wiredOpportunitiesResult = result;
            if (result.data) {
                this.opportunities = result.data;
                this.error = false;
            } else if(result.error) {
                console.log('Error occurred:', result.error);
                this.error = true;
                this.opportunities = undefined;
            }
        }
    }

    handleRafraichir() {
        if (this.wiredOpportunitiesResult) {
          refreshApex(this.wiredOpportunitiesResult)
            .catch((error) => {
              this.error = error; // Gérer les erreurs
            });
        } else {
            this.error = true;
        }
      }
}