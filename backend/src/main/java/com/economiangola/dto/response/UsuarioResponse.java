// src/main/java/com/economiangola/dto/response/UsuarioResponse.java
package com.economiangola.dto.response;

import lombok.*;

import java.time.Instant;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioResponse {

    private Long id;
    private String nome;
    private String email;
    private String avatarUrl;
    private String bio;
    private List<String> perfis;
    private long totalSeguidores;
    private long totalSeguindo;
    private PerfilEstudanteResponse perfilEstudante;
    private Instant criadoEm;
}
