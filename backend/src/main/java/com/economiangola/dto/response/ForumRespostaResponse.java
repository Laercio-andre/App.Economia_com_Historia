// src/main/java/com/economiangola/dto/response/ForumRespostaResponse.java
package com.economiangola.dto.response;

import lombok.*;

import java.time.Instant;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ForumRespostaResponse {

    private Long id;
    private String corpo;
    private ConteudoResponse.AutorResumo autor;
    private Boolean aceite;
    private long totalLikes;
    private List<ForumRespostaResponse> filhos;
    private Instant criadoEm;
    private Instant actualizadoEm;
}
