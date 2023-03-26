# ACTL4001 Project - SOA Research Relocation Social Insurance Case Study

## Executive Summary
This report details the structure and implementation on the social insurance program designed to help the citizens of Storslysia. Due to climate-related catastrophes, individuals from Storslysia are prone to involuntary displacement, as well as voluntary relocation. This report highlights the strategies behind managing exposure to displacement risk financially due to climate-related events. 

This report outlines the main objectives of the social insurance program, the program design with key features, and the pricing costs to fund the mitigation of displacement risk. More specifically, a gradient boosting model XGBoost in conjunction with a gamma regression objective link is used to model likelihood of claims from the highly volatile hazard data and hazard events. This program ensures the key criterias are met: 
- Reducing Storslysia’s financial commitments from climate catastrophe-related displacement
- Prevent costs of relocation from exceed 10% of Storslysia’s GDP each year
- Coverage of all Storslysia’s population

Assumptions used in our financial modeling are listed in the report, along with the risks and risk mitigation strategies for the implementation of the social insurance program. Finally, data used and limitations in the data is stated in the final section of the report. 

## Objectives
The residents of Storslysia are threatened by the impact of the climate-related catastrophes and are becoming more exposed to displacement risks that arise from these perils. As a consulting firm, we have been hired to design a social insurance program, with the objective to mitigate negative financial impacts of the displacement and relocation on the Storslysia residents that have been adversely impacted by the catastrophes. 

The designed program aims to help manage the exposure to displacement risks.This is achieved through incentivising residents of Storlysia to move out of the high catastrophe areas as well as helping them resettle into new locations. Taking into account the diverse geographic regions and demographics of Strorslysia, the designed program aims to provide benefits to the affected victims which vary based on their current geographic risk. Relocation out of high risk areas helps reduce disaster risk and property claims costs, therefore a program that encourages such displacement will greatly reduce natural perils related claims and serve as a risk mitigation method that can help minimize exposure. With those that are unfortunately affected, the program still aims to help maintain the victim’s quality of life by assisting in their relocation by considering several factors such as the victim’s socio-economic background.

The program will reduce Storlysia’s cost arising from climate catastrophe and prevent arising costs from both voluntary and involuntary displacement from exceeding 10% of Stroslysia’s gross domestic product (GDP). As a social insurance program, the entirety of Storyslysia is taken into consideration and covered. 

### Monitoring and Key metrics
In order to make sure our program has been designed appropriately we will monitor the performance that has been achieved on a quarterly basis. We will review and monitor the social insurance program’s success using the following metrics: 
| Metric | Review |
| --- | ----------- |
|Claims frequency | A reduction in claims frequency from the last reporting date relative to the catastrophic events that has occurred. As the program aims to incentivise the relocation to safer regions, the program should decrease the amounts of claims due to more participants being in areas of lower geographic risk in future periods - if this is not achieved a re-evaluation should be done.|
|Average cost per claim (severity) | Decrease in claims severity as people relocate to safer areas, supported by the program’s scheme. Similar to claims frequency, a re-evaluation is required if a downward trend is not observed.|
|Loss Ratio |With a reduction in claims costs, the loss ratio would give a good indication of how our product is performing and give insight into the profitability of the scheme which is a useful metric to convey to stakeholders. <br/> <br/> In order to ensure that the program is meeting the current financial and profit margins, a re-evaluation of the program will need to be performed quarterly to ensure that a downward loss-ratio trend is achieved. |
|Satisfaction rate | Although the scheme is designed to cover all Storlysia’s residents, the satisfaction of policy holders can indicate how the program is faring and whether it is in fact benefiting the residents as intended.|

## Program Design
The requirements that must be satisfied for a citizen of Storslysia to file a claim under the program are listed below: 

- Address of current location and new location are required. Individual’s filing a claim are required to relocate from a higher to lower risk region. 
- Total property damage costs that arise from voluntary relocation must exceed the median value of owner-occupied housing units in the respective region in order to be eligible for a claim.
- Total property damage costs that arise from involuntary relocation must exceed Ꝕ500,000 in order to be eligible for a claim. 
- Medical reports and test results may be requested as supporting documents in the case of psychological claims.

The design of this social insurance program incentivises the individuals of Storslysia to relocate to areas of lower risk and covers the losses resulting from displacement. It addresses both voluntary and involuntary relocation as a result of a catastrophic event. Relocation tends to include expenses such as building accommodation, replacing lost household items, and addressing psychological challenges that may arise after the event. With these factors in mind, the designed program will aim to help the victims resettle. 

The cost of coverage for voluntary relocation is lower than that of involuntary displacement, which includes expenses such as building accommodation, replacing lost household items, and addressing psychological challenges that may arise after the event. To reduce these costs to a high degree of certainty, efforts must be made to ensure that the costs of both voluntary and involuntary relocation do not exceed 10% of Storslysia's GDP per year. It is essential to provide complete coverage to Storslysia to ensure that everyone affected by the catastrophe is protected and assisted in their relocation.

In the event of a claim, the following is under coverage from this program:

- Finding accommodation 
- Building accommodation 
- Replacing damaged household items
- Replacing lost household items
- Managing psychological challenges associated with the climate catastrophe causing relocation, including but not limited to trauma, mental illness and stress

### Key program features
- In the case of voluntary relocation, a discount is given due to the smaller cost associated with finding and building accommodation, and replacing lost/damaged household items.
- In the case of involuntary relocation, no discount is given, due to the circumstances of the program covering costs associated with damaged household and items, along with finding and building accommodation.

## Pricing/ Cost

### Modelling Claims

To price and find the cost of our program, we first look to model the probability of a claim as well as the amount claimed using historical hazard data given. Due to the high variability of the historical data and hazard event, we have decided to use a gradient boosting model, XGBoost with a gamma regression objective link. 

We split the historical data into 70% training data and 30% testing data, and created the XGBoost model and predicted results using the testing data. The results of the predicted and actual density of results are presented below:

