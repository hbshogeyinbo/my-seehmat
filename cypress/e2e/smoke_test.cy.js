// describe('template spec', () => {
//   it('passes', () => {
//     cy.visit('https://example.cypress.io')
//   })
// })

describe('Smoke Test', () => {
  it('Should load the homepage', () => {
    cy.visit('https://seehmat.com'); // Your actual website URL
    cy.get('h1').should('contain', 'HAMEED SHOGEYINBO'); // Adjusted content to match your homepage's heading
  });

  it('Should navigate to the About section', () => {
    cy.visit('https://seehmat.com'); // Your actual website URL
    cy.get('div[data-scroll="about"]').click(); // Click the About link
    cy.get('div[data-scroll="about"]').should('have.class', 'active'); // Check if the About link gets the "active" class
    cy.get('h1').should('contain', 'HAMEED SHOGEYINBO'); // Verify that the About section content is displayed
  });
});
