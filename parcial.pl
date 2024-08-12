% receta(Plato, Duración, Ingredientes)
receta(empanadaDeCarneFrita, 20, [harina, carne, cebolla, picante, aceite]).
receta(empanadaDeCarneAlHorno, 20, [harina, carne, cebolla, picante]).
receta(lomoALaWellington, 125, [lomo, hojaldre, huevo, mostaza]).
receta(pastaTrufada, 40, [spaghetti, crema, trufa]).
receta(souffleDeQueso, 35, [harina, manteca, leche, queso]).
receta(tiramisu, 30, [vainillas, cafe, mascarpone]).
receta(rabas, 20, [calamar, harina, sal]).
receta(parrilladaDelMar, 40, [salmon, langostinos, mejillones]).
receta(sushi, 30, [arroz, salmon, sesamo, algaNori]).
receta(hamburguesa, 15, [carne, pan, cheddar, huevo, panceta, trufa]).
receta(padThai, 40, [fideos, langostinos, vegetales]).

% elabora(Chef, Plato)
elabora(guille, empanadaDeCarneFrita).
elabora(guille, empanadaDeCarneAlHorno).
elabora(vale, rabas).
elabora(vale, tiramisu).
elabora(vale, parrilladaDelMar).
elabora(ale, hamburguesa).
elabora(lu, sushi).
elabora(mar, padThai).

% cocinaEn(Restaurante, Chef)
cocinaEn(pinpun, guille).
cocinaEn(laPececita, vale).
cocinaEn(laParolacha, vale).
cocinaEn(sushiRock, lu).
cocinaEn(olakease, lu).
cocinaEn(guendis, ale).
cocinaEn(cantin, mar).

% tieneEstilo(Restaurante, Estilo)
tieneEstilo(pinpun, bodegon(parqueChas, 6000)).
tieneEstilo(laPececita, bodegon(palermo, 20000)).
tieneEstilo(laParolacha, italiano(15)).
tieneEstilo(sushiRock, oriental(japon)).
tieneEstilo(olakease, oriental(japon)).
tieneEstilo(cantin, oriental(tailandia)).
tieneEstilo(cajaTaco, mexicano([habanero, rocoto])).
tieneEstilo(guendis, comidaRapida(5)).

% italiano(CantidadDePastas)
% oriental(País)
% bodegon(Barrio, PrecioPromedio)
% mexicano(VariedadDeAjies)
% comidaRapida(cantidadDeCombos)

%PUNTO 1
esCrack(Chef):-
    esChef(Chef),
    trabajaEnAlMenos2RestaurantesOCocinaPadChai(Chef).

esChef(Chef):-
    elabora(Chef,_).

trabajaEnAlMenos2RestaurantesOCocinaPadChai(Chef):-
    elabora(Chef,padThai).
trabajaEnAlMenos2RestaurantesOCocinaPadChai(Chef):-
    cocinaEn(UnRestaurante,Chef),
    cocinaEn(OtroRestaurante,Chef),
    UnRestaurante\=OtroRestaurante.

%PUNTO 2
esOtaku(Chef):-
    esChef(Chef),
    soloTrabajaEnRestauranteDeComidaJaponesa(Chef).

soloTrabajaEnRestauranteDeComidaJaponesa(Chef):-
    forall(cocinaEn(Restaurante,Chef),tieneEstilo(Restaurante,oriental(japon))).

%PUNTO 3
esTop(Plato):-
    esPlato(Plato),
    soloElaboradoPorCracks(Plato).

esPlato(Plato):-
    receta(Plato,_,_).
soloElaboradoPorCracks(Plato):-
    elabora(_,Plato),
    forall(elabora(Chef,Plato),esCrack(Chef)).

%PUNTO 4
esDificil(Plato):-
    esPlato(Plato),
    duracionDeMasDe2HorasOUsaTrufaOEsSouffleDeQueso(Plato).

duracionDeMasDe2HorasOUsaTrufaOEsSouffleDeQueso(Plato):-
    receta(Plato,DuracionMinutos,_),
    DuracionMinutos > 120.
duracionDeMasDe2HorasOUsaTrufaOEsSouffleDeQueso(Plato):-
    receta(Plato,_,Ingredientes),
    member(trufa,Ingredientes).
duracionDeMasDe2HorasOUsaTrufaOEsSouffleDeQueso(souffleDeQueso).

%PUNTO 5
seMereceLaMichelin(Restaurante):-
    esRestaurante(Restaurante),
    tieneUnChefCrack(Restaurante),
    tieneEstiloMichelinero(Restaurante).

esRestaurante(Restaurante):-
    tieneEstilo(Restaurante,_).
tieneUnChefCrack(Restaurante):-
    cocinaEn(Restaurante,Chef),
    esCrack(Chef).
tieneEstiloMichelinero(Restaurante):-
    tieneEstilo(Restaurante,oriental(tailandia)).
tieneEstiloMichelinero(Restaurante):-
    tieneEstilo(Restaurante,bodegon(palermo,_)).
tieneEstiloMichelinero(Restaurante):-
    tieneEstilo(Restaurante,italiano(CantidadDePastas)),
    CantidadDePastas > 5.
tieneEstiloMichelinero(Restaurante):-
    tieneEstilo(Restaurante,mexicano(VariedadDeAjies)),
    member(habanero,VariedadDeAjies),
    member(rocoto,VariedadDeAjies).

%PUNTO 6
tieneMayorRepertorio(UnRestaurante,OtroRestaurante):-
    esRestaurante(UnRestaurante),
    esRestaurante(OtroRestaurante),
    %UnRestaurante\=OtroRestaurante, / no hace falta aclarar que deben ser distintos ya que jamás podrá cumplir la concidición de que el restaurante tenga más platos que él mismo.
    tieneChefQueElaboraMasPlatos(UnRestaurante,OtroRestaurante).

tieneChefQueElaboraMasPlatos(UnRestaurante,OtroRestaurante):-
    obtenerCantidadDePlatos(UnRestaurante,UnaCantidad),
    obtenerCantidadDePlatos(OtroRestaurante,OtraCantidad),
    UnaCantidad>OtraCantidad.

obtenerCantidadDePlatos(Restaurante,Cantidad):-
    cocinaEn(Restaurante,Chef),
    findall(Plato,elabora(Chef,Plato),ListaDePlatos),
    length(ListaDePlatos,Cantidad).

%PUNTO 7
calificacionGastronomica(Restaurante,Calificacion):-
    esRestaurante(Restaurante),
    obtenerCantidadDePlatos(Restaurante,Cantidad),
    Calificacion is Cantidad * 5.