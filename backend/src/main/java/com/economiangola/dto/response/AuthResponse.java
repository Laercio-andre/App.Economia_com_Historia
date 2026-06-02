// src/main/java/com/economiangola/dto/response/AuthResponse.java
package com.economiangola.dto.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {

    private String token;
    private String refreshToken;
    private String tipo;
    private Long usuarioId;
    private String nome;
    private String email;
    private List<String> perfis;
}
