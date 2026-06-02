// src/main/java/com/economiangola/dto/response/PerfilEstudanteResponse.java
package com.economiangola.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerfilEstudanteResponse {

    private Integer pontuacaoTotal;
    private Integer quizzesFeitos;
    private Integer artigosLidos;
    private Integer streakDias;
}
