import { Component, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { Router } from '@angular/router';

import { Family } from 'src/app/models/family.model';
import { FamilyService } from 'src/app/services/family.service';

@Component({
  selector: 'change',
  templateUrl: './change.component.html',
  styleUrls: ['./change.component.css']
})
export class ReviewChangesComponent implements OnInit {

  modalVisible: boolean = false;

  family: Family = {} as Family;
  private familySubscription: Subscription = new Subscription;

  constructor(public familyService: FamilyService, private router: Router) { }

  ngOnInit() {
    this.family = this.familyService.getFamily();
    this.familySubscription = this.familyService.getFamilyUpdateListener()
      .subscribe((family: Family) => {
        this.family = family;
      });
  }

  ngOnDestroy() {
    this.familySubscription.unsubscribe();
  }

  showModal() {
    this.modalVisible = true;
  }

  navigate() {
    this.router.navigate(['/appointment'])
  }

}
