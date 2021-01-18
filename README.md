# PokeBowl

PokeBowl helps you to expand you knowledge of Pokemon.

Inspired by the game in early pokemon episodes, it lets you guess pokemons from their silhouette! 

![demo play](docs/img/WhoIsThatPokemon.gif "")

# Architecture and implementation details
- The source code follows the MVVM pattern to ensure a degree of testability
- Layouts are done in SwiftUI
- Dependencies shared between ViewModels go through a central object (ViewModelProvider) which is passed to any View in the hierarchy using SwiftUI's `@Environment`
- 'Provider' layers are added to increase ViewModel testablity (they can easily be replaced by mocks)

## Next steps would be
- Proper error handling
- Caching

## Note
During development I've found at least 1 pokemon that is listed in PokeAPI's Generations that has an actual UR which returns a 404. In this case, the pokedex might keep on loading due to lack of error handling!
