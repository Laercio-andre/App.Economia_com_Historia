// src/main/java/com/economiangola/dto/response/ComentarioResponse.java
package com.economiangola.dto.response;

import lombok.*;

import java.time.Instant;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComentarioResponse {

    private Long id;
    private String texto;
    private ConteudoResponse.AutorResumo autor;
    private long totalLikes;
    private List<ComentarioResponse> filhos;
    private Instant criadoEm;
    private Instant actualizadoEm;
}
